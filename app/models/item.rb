class Item < ApplicationRecord
  has_one_attached :image

  belongs_to :genre
  has_many :cart_items, dependent: :destroy
  has_many :order_details

  enum is_active: {for_sale: 0, sales_stop: 1 }

  
end
