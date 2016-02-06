class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :list, index: { name: 'index_items_on_list_id' }
      t.string :name
      t.decimal :qty, precision: 10, scale:2
      t.string :unit
      t.decimal :price, precision: 10, scale: 2
      t.boolean :done, default: false
      

      t.timestamps
    end
  end
end
