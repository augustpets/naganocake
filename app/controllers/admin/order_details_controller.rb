class Admin::OrderDetailsController < ApplicationController
  def update
    @order = Order.find(params[:order_id])
    @order_detail = @order.order_details.find(params[:id])

    if @order_detail.update(order_detail_params)
      update_order_status(@order)
      redirect_to admin_order_path(@order), notice: "製作ステータスを更新しました"
    else
      redirect_to admin_order_path(@order), alert: "更新に失敗しました"
    end
    
  end

  private

  def order_detail_params
    params.require(:order_detail).permit(:making_status)
  end

  def update_order_status(order)
    if order.order_details.complete.count == order.order_details.count
      order.update(status: "preparing")
    elsif order.order_details.in_production.exists?
      order.update(status: "production")
    end
  end

end
