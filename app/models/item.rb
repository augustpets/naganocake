class Item < ApplicationRecord
  has_one_attached :image

  belongs_to :genre, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :order_details
  
  validates :image, presence: true
  validates :name, presence: true
  validates :introduction, presence: true
  validates :price, presence: true



  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end

  def price_in_tax
    (price * 1.1).floor
  end
end
