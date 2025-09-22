class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_order

  def index
    @order = Order.all.includes(:customer)
    @orders = Order.page(params[:page])
  end

  def show
    @order = Order.find(params[:id])
    @orders = @order.orders.page(params[:page])
  end

  def update
    @order.update(order_params)
    redirect_to admin_order_path(@order)
  end

  private

  def set_order
    @order  = Order.find(params[:id])
  end

  def order_params
    params.require(:order).parmit(:status)
  end
end
