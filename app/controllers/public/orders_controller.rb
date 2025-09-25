class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!, only: [:new, :confirm, :create, :thanks, :index, :show]
  
  def new
    @order = Order.new
  end
  
  def confirm
    puts "==== params[:order] at CONFIRM ===="
    puts params[:order].inspect
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @cart_items = CartItem.where(customer_id: current_customer.id)
    @shipping_cost = 800
    @selected_payment_method = params[:order][:payment_method]
    
    @cart_items_price = @cart_items.sum { |item| item.item.price * item.amount }
    @total_payment = @shipping_cost + @cart_items_price

    @address_type = params[:order][:address_type]
     logger.debug "==== address_type: #{@address_type} ===="
    case @address_type
    when "customer_address"
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + current_customer.first_name
    when "registered_address"
      unless params[:order][:registered_address_id] == ""
        selected = Address.find(params[:order][:registered_address_id])
        @order.postal_code = selected.postal_code
        @order.address = selected.address
        @order.name = selected.name
      else	 
        render :new
      end
    when "new_address"
      if params[:order][:postal_code].present? &&
        params[:order][:address].present? &&
        params[:order][:name].present?
        @order.postal_code = params[:order][:postal_code]
        @order.address = params[:order][:address]
        @order.name = params[:order][:name]
    else
      render :new
    end
  end
  end
  
  def create
    @order = Order.new
    @order.customer_id = current_customer.id
    @order.shipping_cost = 800
    @cart_items = CartItem.where(customer_id: current_customer.id)

    @cart_items_price = @cart_items.sum { |item| item.item.price * item.amount }
    @order.total_payment = @order.shipping_cost + @cart_items_price

    @order.payment_method = params[:order][:payment_method]
    if @order.payment_method == "credit_card"
      @order.status = 1
    else
      @order.status = 0
    end
    
    address_type = params[:order][:address_type]
    case address_type
    when "customer_address"
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + current_customer.first_name

    when "registered_address"
      Address.find(params[:order][:registered_address_id])
      selected = Address.find(params[:order][:registered_address_id])
      @order.postal_code = selected.postal_code
      @order.address = selected.address
      @order.name = selected.name

    when "new_address"
      @order.postal_code = params[:order][:new_postal_code]
      @order.address = params[:order][:new_address]
      @order.name = params[:order][:new_name]
    end

    if @order.save
      making_status = (@order.status == 0 ? 0 : 1)
      @cart_items.each do |cart_item|
        OrderDetail.create!(order_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.price, amount: cart_item.amount, making_status: making_status)
      end
      @cart_items.destroy_all
      redirect_to complete_orders_path
    else
      render :confirm 
    end
  end    

  
  def index
    @orders = Order.where(customer_id: current_customer.id).order(created_at: :desc)
  end
  
  def show
    @order = Order.find(params[:id])
    @order_details= OrderDetail.where(order_id: @order.id)
  end 
  
  def thanks
  end

  private

  def order_params
    params.require(:order).permit(:name, :address, :payment_method, :postal_code)
  end
end


