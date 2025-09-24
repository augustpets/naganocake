class Address < ApplicationRecord
  belongs_to :customer

  validates :customer_id, presence: true
  validates :name,        presence: true
  validates :postal_code, presence: true
  validates :address,     presence: true

  validates :postal_code, format: { with: /\A\d{7}\z/, message: "は7桁の数字で入力してください" }
  validates :address, length: { minimum: 2, message: "は2文字以上で入力してください" }
end
