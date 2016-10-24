class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.references :user, index: { name: 'index_units_on_user_id' }
      t.string :name
    end
  end
end
