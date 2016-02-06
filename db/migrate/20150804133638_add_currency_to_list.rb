class AddCurrencyToList < ActiveRecord::Migration
  def change
    add_column :lists, :currency, :string
  end
end
