class Admin::HomesController < ApplicationController
  def top
    @orders = Order.includes(:customer).page(params[:page])
  end
end
