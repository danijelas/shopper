class Category < ActiveRecord::Base
  
  belongs_to :user
  has_many :items

  validates :name, presence: true, uniqueness: { scope: :user_id, case_sensitive: false }

  before_destroy :check_for_items

private

  def check_for_items
    if items.any?
      errors[:base] << "cannot delete categorie that has items"
      return false
    end
  end
  
end
