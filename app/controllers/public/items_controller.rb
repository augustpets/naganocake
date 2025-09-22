class Public::ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @items = Item.page(params[:page]).per(8)
  end

  def show
    @item = Item.find(params[:id])
  end

end
