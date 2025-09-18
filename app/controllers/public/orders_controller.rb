class Public::OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def confirm

    @shipping_cost = 800
    @selected_pay_method = params[:order][:pey_method]
  end
end

  def thanks
  end

  def create
    @order = Order.new
    @order.customer_id = current_member.id
    @order.shipping_cost = 800
    
  end

  def index
    @orders = Order.where(member_id: current_member.id).order(created_at: :desc).
  end

  def show
    @order = Order.find(params[:id])
    @order_datails = OrderDetail.where(order_id: @order.id)
  end

end
