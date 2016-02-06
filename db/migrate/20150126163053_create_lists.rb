class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.references :user, index: { name: 'index_lists_on_user_id' }
      t.string :name

      t.timestamps
    end
  end
end
