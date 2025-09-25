class Public::ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @genres = Genre.all
    @items = Item.page(params[:page]).per(8)
  end

  def show
    @genres = Genre.all
    @item = Item.find(params[:id])
  end

end
