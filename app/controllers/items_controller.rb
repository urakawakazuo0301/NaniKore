class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

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


  private

  def item_params
    params.require(:item).permit(:name, :category_id, :quantity_id, :notes, :color, {images: []}).merge(user_id: current_user.id)
  end

end
