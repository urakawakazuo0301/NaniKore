class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_item, only: [:show, :edit, :update, :destroy, :mark_as_used, :delete_image]
  before_action :move_to_index, only: [:show, :edit]

  def index
  end
  
  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to '/'
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @item.update(item_params)
      if params[:item][:images].present?
        new_images = params[:item][:images].select { |img| img.is_a?(ActionDispatch::Http::UploadedFile) }
        @item.images.attach(new_images) unless new_images.empty?
      end
      redirect_to item_path(@item)
    else
      render 'edit', status: :unprocessable_entity
    end
  end


  def upload_image
    @image_blob = create_blob(params[:image])
    render json: @image_blob
  end

  def search
    @items = current_user.items.search(search_params)
    session[:search_filters] = params.slice(:name, :category_id, :quantity_id, :color_id, :notes)
  end

  def mark_as_used
    @item.update(used: !@item.used)
    
    respond_to do |format|
      format.html { redirect_to search_items_path(session[:search_filters]), notice: 'アイテムの状態が更新されました。' }
      format.json { render json: { success: @item.used, item_id: @item.id } }
      format.js
    end
  end

  def destroy
    @item.destroy
    redirect_to search_items_path(session[:search_filters])
  end
  

  def delete_image
    image = ActiveStorage::Blob.find(params[:id])
    image.purge
    head :no_content
  end

  private

  def set_item
    @item = current_user.items.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    redirect_to '/', alert: 'アクセスできません。'
  end

  def move_to_index
    redirect_to '/' unless current_user.id == @item.user_id
  end

  def item_params
    params.require(:item).permit(:name, :category_id, :quantity_id, :notes, :color_id, :used, {images: []}).merge(user_id: current_user.id, images: uploaded_images)
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
