class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_order, only: [:show, :update]

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details.includes(:item)
  end

  def update
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: "注文ステータスを更新しました。"
    else
      render :show
    end
  end

  private

  def set_order
    @order  = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end

  def order_detail_params
    params.require(:order_detail).permit(:making_status)
  end

  def update_order_status(order)
    if order.order_details.complete.count == order.order_details.count
    order.update(status: "preparing")
  elsif order.order_details.in_production.exists?
    order.update(status: "making")
  end
end
end
