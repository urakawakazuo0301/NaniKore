class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
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

  private

  def set_item
    if params[:id]
    @item = Item.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to '/', alert: 'アクセスできません。'
  end


  def item_params
    params.require(:item).permit(:name, :category_id, :quantity_id, :notes, :color_id, :used, {images: []}).merge(images: uploaded_images)
  end

  def search_params
    params.permit(:name, :category_id, :quantity_id, :color_id, :notes)
  end

  # アップロード済み画像の検索
  def uploaded_images
    params[:item][:images].drop(1).map{|id| ActiveStorage::Blob.find(id)} if params[:item][:images]
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
