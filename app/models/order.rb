class Order < ApplicationRecord
  belongs_to :customer
  before_create :generate_order_id
  has_many :items, through: :order_details
  has_many :order_details, dependent: :destroy
  has_many :addresses

  validates :postal_code, presence: true
  validates :address, presence: true
  validates :name, presence: true
  validates :payment_method, presence: true


  enum payment_method: { credit_card: 0, transfer: 1 }

  enum status: { waiting: 0, paid_up: 1, production: 2, preparing: 3, shipped: 4 }

  after_update :update_making_status, if: :saved_change_to_status?
  
  private

  def update_making_status
    if status == "paid_up"
      order_details.where(making_status: OrderDetail.making_statuses[:cannot_start])
                   .update_all(making_status: OrderDetail.making_statuses[:waiting_for_make])
    end
  end

  def generate_order_id
    self.order_id = Time.current.strftime('%Y%m%d%H%M%S') + rand(1000..9999).to_s
  end

end
