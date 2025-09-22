class Item < ApplicationRecord
  has_one_attached :image

  belongs_to :genre
  has_many :cart_items, dependent: :destroy
  has_many :order_details
  
  validates :image, presence: true
  validates :name, presence: true
  validates :introduction, presence: true
  validates :price, presence: true



  def get_image
    if image.attached?
        image.variant(resize_to_fill: [width = 300, height = 300]).processed
    end
  end

  def price_in_tax
    (price * 1.1).floor
  end
end
