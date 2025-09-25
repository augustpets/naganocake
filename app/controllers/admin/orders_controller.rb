class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_order, only: [:show, :update]

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details.includes(:item)
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: "注文ステータスを更新しました"
    else
      redirect_to admin_order_path(@order), alert: "更新に失敗しました"
    end
  end

  private

  def set_order
    @order  = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end

end
