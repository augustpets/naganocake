class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!, only: [:new, :confirm, :create, :thanks, :index, :show]
  
  def new
    @order = Order.new
    @order.shipping_cost = 800
  end

  def confirm
    @order = Order.new(order_params)
     @cart_items = CartItem.where(customer_id: current_customer.id)
     @shipping_cost = 800
     @selected_payment_method = params[:order][:payment_method]

     ary = []
     @cart_items.each do |cart_item|
       ary << cart_item.item.price_in_tax*cart_item.amount
    end

     @cart_items_price = ary.sum

     @total_payment = @shipping_cost + @cart_items_price
     @address_type = params[:order][:address_type]
     case params[:order][:address_type]
     when "customer_address"
       @selected_address = current_customer.postal_code.to_s + " " + current_customer.address.to_s + " " + current_customer.last_name.to_s + current_customer.first_name.to_s
     when "registered_address"
       unless params[:order][:registered_address_id] == ""
         selected = Address.find(params[:order][:registered_address_id])
         @selected_address = selected.postal_code + " " + selected_address + " " + selected.name
       else
         render :new
     end

     when "new_address"
       unless params[:order][:new_postal_code] == "" && params[:order][:new_address] == "" && params[:order][:new_name] == ""
         @second_address = params[:order][:new_postal_code] + " " + params[:order][:new_address] + " " + params[:order][:new_name]
       else
        render :new
       end
     end
   end

  def thanks
  end

  def create
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @order.status ||= 0
    @cart_items = CartItem.where(customer_id: current_customer.id)
    @shipping_cost = 800
    @order.shipping_cost = @shipping_cost
    @order.total_payment = @shipping_cost + @cart_items.sum { |ci| ci.item.price_in_tax * ci.amount }

    address_type = params[:order][:address_type]
    if address_type == "customer_address"
      @order.postal_code = current_customer.postal_code
      @order.address     = current_customer.address
      @order.name        = "#{current_customer.last_name} #{current_customer.first_name}"
    elsif address_type == "registered_address" && params[:order][:registered_address_id].present?
      selected = Address.find(params[:order][:registered_address_id])
      @order.postal_code = selected.postal_code
      @order.address     = selected.address
      @order.name        = selected.name
    elsif address_type == "new_address"
      @order.postal_code = params[:order][:new_postal_code]
      @order.address     = params[:order][:new_address]
      @order.name        = params[:order][:new_name]
    end

    if @order.save
      @cart_items.each do |cart_item|
        OrderDetail.create!(
          order_id: @order.id,
          item_id: cart_item.item.id,
          price: cart_item.item.price_in_tax,
          amount: cart_item.amount,
          making_status: 0
          )
        end      
        @cart_items.destroy_all
        redirect_to thanks_public_orders_path
      else
        render :new
      end
    end


  def index
    @orders = Order.where(customer_id: current_customer.id).order(created_at: :desc)
  end

  def show
    @order = Order.find(params[:id])
    @order_details = OrderDetail.where(order_id: @order.id)
  end

  private

  def order_params
    params.require(:order).permit(:name, :address, :payment_method, :postal_code, :status)
  end

end

