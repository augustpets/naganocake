class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!

  def index
    @cart_items = current_customer.cart_itemsR
    @total_amount = @cart_items.inject(0) { |sum, item| sum + item.subtotal }
  end

  def update
    @cart_item = current_customer.cart_items.find(params[:id])
    if @cart_item.update(cart_item_params)
      redirect_to cart_items_path, notice: "数量を変更しました"
    else
      redirect_to cart_items_path, notice: "数量の変更に失敗しました"
    end
  end

  def destroy
    cart_item = current_customer.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_items_path, notice: "商品をカートから削除しました"
  end

  def destroy_all
    current_customer.cart_items.destroy_all
    redirect_to cart_items_path, notice: "カートを空にしました"
  end

  def create
    @cart_item = current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])
    
    if @cart_item
      @cart_item.amount += params[:cart_item][:amount].to_i
    else
      @cart_item = current_customer.cart_items.new(cart_item_params)
    end

    if @cart_item.save
      redirect_to cart_items_path, notice: "商品をカートに追加しました"
    else
      redirect_to public_item_path(params[:cart_item][:item_id]), alert: "商品をカートに追加できませんでした"
    end
  end

  private
  
  def cart_item_params
    params.require(:cart_item).permit(:customer_id, :item_id, :amount)
  end
  
end
