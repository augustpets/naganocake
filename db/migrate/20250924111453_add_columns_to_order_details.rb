class AddColumnsToOrderDetails < ActiveRecord::Migration[6.1]
  def change
    add_reference :order_details, :order, null: false, foreign_key: true
    add_reference :order_details, :item, null: false, foreign_key: true

    add_column :order_details, :amount, :integer, null: false
    add_column :order_details, :price, :integer, null: false
    add_column :order_details, :making_status, :integer, null: false, default: 0
  end
end
