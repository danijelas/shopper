class List < ActiveRecord::Base
  belongs_to :user

  has_many :items, -> { order(category_id: :asc) }, dependent: :destroy
  accepts_nested_attributes_for :items, allow_destroy: true
  validates :name, presence: true, uniqueness: { scope: :user_id, case_sensitive: false }

  before_save :set_currency

  def total_sum
    items.select { |item| item.done == true }.map(&:item_sum).sum
    # map { |e| e.item_sum  }
  end

  def set_currency
    self.currency = user.currency unless self.currency?
  end

end
