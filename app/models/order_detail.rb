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

end
