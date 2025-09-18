class Public::OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def confirm
    @cart_items = CartItem.where(member_id: current_member.id)
    @postage = 800
    @selected_pay_method = params[:order][:pey_method]
  end
end

  def thanks
  end

  def create
  end

  def index
    @orders = Order.where(member_id: current_member.id).order(created_at: :desc).
  end

  def show
    @order = Order.find(params[:id])
    @order_datails = OrderDetail.where(order_id: @order.id)
  end

end
