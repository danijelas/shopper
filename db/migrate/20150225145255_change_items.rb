class ChangeItems < ActiveRecord::Migration
  def change
    change_column :items, :qty, :decimal, precision: 10, scale:2, default: 0
    change_column :items, :price, :decimal, precision: 10, scale:2, default: 0.00
  end
end
