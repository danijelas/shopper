class RemoveCurrencyFromItem < ActiveRecord::Migration
  def change
    remove_column :items, :currency, :string
  end
end
