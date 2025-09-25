class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :item

  def subtotal
    item.price_in_tax * amount
  end

  enum making_status: {
    cannot_start: 0,    
    waiting_for_make: 1, 
    in_production: 2,    
    complete: 3          
  }

  after_update :update_order_status, if: :saved_change_to_making_status?

  private

  def update_order_status
    if in_production?
      order.update(status: :production) unless order.production?
      return
    end
    
    if order.order_details.all?(&:complete?)
      order.update(status: :preparing) unless order.preparing?
    end
  end
end

