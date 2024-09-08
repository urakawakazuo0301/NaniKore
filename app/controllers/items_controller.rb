class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_item, only: [:update]

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

  def update
  end


  def upload_image
    @image_blob = create_blob(params[:image])
    render json: @image_blob
  end

  def search
    @items = Item.search(search_params)
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :category_id, :quantity_id, :notes, :color_id, {images: []}).merge(user_id: current_user.id, images: uploaded_images)
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
