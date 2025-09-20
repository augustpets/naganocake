class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :item

  enum making_status: {
    cannnot_start: 0,    
    waiting_for_make: 1, 
    in_production: 2,    
    complete: 3          
  }

end
