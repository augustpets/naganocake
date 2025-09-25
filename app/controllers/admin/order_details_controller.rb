class Admin::OrderDetailsController < ApplicationController
  def update
    @order = Order.find(params[:order_id])
    @order_detail = @order.order_detail.find(params[:id])

    if @order_detail.update(making_status: params[:order_detail][:making_status])
      redirect_to admin_order_path(@order), notice: "製作ステータスを更新しました"
    else
      redirect_to admin_order_path(@order), alert: "更新に失敗しました"
    end
    
  end

  private

  def order_detail_params
    params.require(:order_detail).permit(:making_status)
  end
end
