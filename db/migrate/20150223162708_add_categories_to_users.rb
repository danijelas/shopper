class AddCategoriesToUsers < ActiveRecord::Migration
  def change
    User.all.each do |user|
      user.categories << Category.new(name: 'Dairy')
      user.categories << Category.new(name: 'Bakery')
      user.categories << Category.new(name: 'Fruits & Vegetables')
      user.categories << Category.new(name: 'Meat')
      user.categories << Category.new(name: 'Home Chemistry')
    end
  end
end
