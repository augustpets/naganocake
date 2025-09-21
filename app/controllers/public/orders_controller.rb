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
       ary << cart_item.item.price*cart_item.quantity
    end

     @cart_items_price = ary.sum

     @total_payment = @shipping_cost + @cart_items_price
     @address_type = params[:order][:address_type]
     case @address_type
     when "customer_address"
       @selected_address = current_customer.postal_code.to_s + " " + current_customer.address.to_s + " " + current_customer.last_name.to_s + current_customer.first_name.to_s
     when "registered_address"
       unless params[:order][:registered_address_id] == ""
         selected = Address.find(params[:order][:registered_address_id])
         @selected_address = current_customer.postal_code.to_s + " " + selected_address.to_s + " " + selected.name.to_s
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
    @order.customer_id = current_customer.id
    @order = Order.new(order_params)
    if @order.save
      redirect_to thanks_public_orders_path
    else
      render :new
    end
     @order.shipping_cost = 800
     @cart_items = CartItem.where(customer_id: current_customer.id)
     ary = []
     @cart_items.each do |cart_item|
       ary << cart_item.item.price*cart_item.quantity
    end
     @cart_items_price = ary.sum
     @order.total_payment = @order.shipping_cost + @cart_items_price
     @order.payment_method = params[:order][:payment_method]
     if @order.payment_method == "credit_card"
       @order.status = 0
     else
       @order.status = 1
     end

    address_type = params[:order][:address]
     case address_type
   when "customer_address"
     @order.postal_code = current_customer.postal_code
     @order.address = current_customer.address
     @order.name = current_customer.last_name_name + current_customer.first_name
   when "registered_address"
     Address.find(params[:order][:registered_address_id])
     selected = Address.find(params[:order][:registered_address_id])
     @order.postal_code = selected.postal_code
     @order.address = selected.address
     @order.name = selected.name
   when "new_address"
     @order.postal_code = params([:order][:new_postal_code])
     @order.address = params([:order][:new_address])
     @order.name = params([:order][:new_name])
   end

   if @order.save
     if @order.status == 1
       @cart_items.each do |cart_item|
         OrderDetail.create!(order_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.price, quantity: cart_item.quantity, making_status: 1)
       end
     else
       @cart_items.each do |cart_item|
         OrderDetail.create!(order_id: @order.id, item_id: cart_item.item.id, pricre: cart_item.item.price, quantity: cart_item.quantity, making_status: 0)
       end
     end
     @cart_items.destroy_all
     redirect_to public_cart_items_path
   else
     render :items
   end
   end

  def index
    @orders = Order.where(customer_id: current_customer.id).order(created_at: :desc)
  end

  def show
    @order = Order.find(params[:id])
    @order_datails = OrderDetail.where(order_id: @order.id)
  end

  private

  def order_params
    params.require(:order).permit(:name, :address, :payment_method, :postal_code)
  end

end

