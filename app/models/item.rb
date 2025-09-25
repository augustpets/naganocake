class Item < ApplicationRecord
  has_one_attached :image

  belongs_to :genre
  has_many :cart_items, dependent: :destroy
  has_many :order_details
  
  validates :image, presence: true
  validates :name, presence: true
  validates :introduction, presence: true
  validates :price, presence: true


#画像のサイズを変更するメソッド
  def get_image
    if image.attached?
        image.variant(resize_to_fill: [width = 300, height = 300]).processed
    end
  end

#税込金額を算出するメソッド
  def price_in_tax
    (price * 1.1).floor  #(税抜価格✕税率).小数点以下切り捨てメソッド
  end
end
