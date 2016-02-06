class AddMiscellaneousCategorieToUsers < ActiveRecord::Migration
  def change
    User.all.each do |user|
      user.categories << Category.new(name: 'Miscellaneous')
    end
  end
end
