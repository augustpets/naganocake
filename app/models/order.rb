class Order < ApplicationRecord
  has_many :items, through: :order_items
  has_many :order_items

  validates :postal_code, presence: true
  validates :address, presence: true
  validates :name, presence: true
  validates :payment_method, presence: true

  enum payment_method: { credit_card: 0, transfer: 1 }
end
