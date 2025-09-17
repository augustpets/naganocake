class Admin::ItemsController < ApplicationController
  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.save
    redirect_to '/admin/items/new'
  end



  private
  def item_params
    params.require(:item).permit(:name, :intorduction, :price, :is_active, :image)
  end
end
