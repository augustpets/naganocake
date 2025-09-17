class Public::OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def confirm
  end

  def thanks
  end

  def create
  end

  def index
    @order = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end
end
