class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :mark_as_used, :delete_image, :upload_image]

  def index
    @items = policy_scope(Item)
  end

  def new
    @item = Item.new
    authorize @item
  end

  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id
    authorize @item
    if @item.save
      redirect_to '/', notice: 'アイテムを登録しました。'
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    authorize @item
  end

  def edit
    authorize @item
  end

  def update
    authorize @item
    if @item.update(item_params)
      if params[:item][:images].present?
        new_images = params[:item][:images].select { |img| img.is_a?(ActionDispatch::Http::UploadedFile) }
        @item.images.attach(new_images) unless new_images.empty?
      end
      redirect_to item_path(@item), notice: 'アイテムの情報が更新されました。'
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def upload_image
    if @item
      authorize @item
    else
      authorize Item, :create?
    end

    @image_blob = create_blob(params[:image])
    render json: @image_blob
  end

  def search
    @items = policy_scope(Item).search(search_params)
    session[:search_filters] = params.slice(:name, :category_id, :quantity_id, :color_id, :notes)
  end

  def mark_as_used
    authorize @item
    @item.update(used: !@item.used)

    respond_to do |format|
      format.html { redirect_to search_items_path(session[:search_filters]), notice: 'アイテムの状態が更新されました。' }
      format.json { render json: { success: @item.used, item_id: @item.id } }
      format.js
    end
  end

  def destroy
    authorize @item
    @item.destroy
    redirect_to search_items_path(session[:search_filters]), notice: 'アイテムを削除しました。'
  end

  def delete_image
    authorize @item
    image = ActiveStorage::Blob.find(params[:id])
    image.purge
    head :no_content
  end

  def suggest_name
    authorize Item, :create?

    blob = ActiveStorage::Blob.find(params[:blob_id])
    image_data = Base64.strict_encode64(blob.download)
    content_type = blob.content_type

    categories = Category.all.reject { |c| c.id == 1 }.map(&:name)
    colors = Color.all.map(&:name)

    client = ::OpenAI::Client.new(access_token: Rails.application.credentials.openai[:api_key])

    response = client.chat(
      parameters: {
        model: 'gpt-4o',
        response_format: { type: 'json_object' },
        messages: [
          {
            role: 'user',
            content: [
              {
                type: 'image_url',
                image_url: {
                  url: "data:#{content_type};base64,#{image_data}"
                }
              },
              {
                type: 'text',
                text: <<~PROMPT
                  この画像に写っている付属品・部品・道具を分析してください。

                  以下のJSON形式のみで回答してください:
                  {
                    "name": "アイテム名（日本語、具体的に）",
                    "category": "カテゴリー名（下記リストから最も適切なものを1つ）",
                    "color": "カラー名（下記リストから最も近いもの。判別できない場合はnull）",
                    "notes": "画像内の文字・ラベル・型番・メーカー名など（読み取れるものをすべて。なければ空文字）"
                  }

                  カテゴリー（いずれか1つ）:
                  #{categories.join('、')}

                  カラー（いずれか1つ、またはnull）:
                  #{colors.join('、')}
                PROMPT
              }
            ]
          }
        ],
        max_tokens: 300
      }
    )

    result = JSON.parse(response.dig('choices', 0, 'message', 'content'))

    category = Category.all.find { |c| c.name == result['category'] }
    color = Color.all.find { |c| c.name == result['color'] } if result['color'].present?

    render json: {
      name: result['name'],
      category_id: category&.id,
      color_id: color&.id,
      notes: result['notes']
    }
  end

  private

  def set_item
    @item = Item.find(params[:id]) if params[:id]
  rescue ActiveRecord::RecordNotFound
    redirect_to '/', alert: 'アクセスできません。'
  end

  def item_params
    params.require(:item).permit(:name, :category_id, :quantity_id, :notes, :color_id, :used,
                                 { images: [] }).merge(images: uploaded_images)
  end

  def search_params
    params.permit(:name, :category_id, :quantity_id, :color_id, :notes)
  end

  # アップロード済み画像の検索
  def uploaded_images
    params[:item][:images].drop(1).map { |id| ActiveStorage::Blob.find(id) } if params[:item][:images]
  end

  # blobデータの作成
  def create_blob(file)
    ActiveStorage::Blob.create_and_upload!(
      io: file.open,
      filename: file.original_filename,
      content_type: file.content_type
    )
  end
end
