class Order < ApplicationRecord
  has_many :items, through: :order_items
  has_many :order_items

  validates :postal_code, presence: true
  validates :address, presence: true
  validates :name, presence: true
  validates :payment_method, presence: true

  enum payment_method: { credit_card: 0, transfer: 1 }

  enum status: { waiting: 0, paid_up: 1, production: 2 preparing: 3, shpped: 4}
end
