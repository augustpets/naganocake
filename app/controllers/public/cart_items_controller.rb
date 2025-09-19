class Public::CartItemsController < ApplicationController
  def index
  end

  def update
    @cart_item = current_customer.cart_item.find(params[:id])
    @cart_item.update(cart_item_params)
    @cart_items = current_customer.cart_items.all
    @total_amount = @cart_item.inject(0) { |sum, item| sum = item.subtotal }
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
    params.require(:cart_item).permit(:customer_id, :item_id, :amount)
  end
  
end
