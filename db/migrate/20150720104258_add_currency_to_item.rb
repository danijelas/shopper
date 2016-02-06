class AddCurrencyToItem < ActiveRecord::Migration
  def change
    add_column :items, :currency, :string
  end
end
