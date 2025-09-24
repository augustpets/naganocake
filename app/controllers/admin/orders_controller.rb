class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_order, only: [:show, :update]

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details.includes(:item)
  end

  def update
    @order_detail = OrderDetail.find(params[:id])
    @order_detail.update(making_status: params[:order_detail][:making_status])
    update_order_status(@order_detail.order)
    redirect_to  admin_order_path(@order_datail.order), notice: "更新に成功しました。"
  end

  private

  def set_order
    @order  = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end

  def update_order_status(order)
    if order.order_details.completed.counted.count == order.order_details.count
    order.update(status: "preparing")
  elsif order.order_details.in_production.exists?
    order.update(status: "making")
  end
end
end
