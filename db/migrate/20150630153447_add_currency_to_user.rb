class AddCurrencyToUser < ActiveRecord::Migration
  def change
    add_column :users, :currency, :string
  end
end
