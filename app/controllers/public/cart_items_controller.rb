class Public::CartItemsController < ApplicationController
  def index
  end

  def update
    @cart_item = current_customer.cart_item.find(params[:id])
    @cart_item
  end

  def destroy
  end

  def destroy_all
  end

  def create
    @cart_item = @item_id
  end

  private
  
  def cart_item_params
    params.require(:cart_item).permit(:item_id, :amount)
  end
  
end
