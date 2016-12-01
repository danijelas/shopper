class Item < ActiveRecord::Base
  
  belongs_to :list
  belongs_to :category
  before_validation :set_category, if: 'self.category.nil?'

  validates :name, presence: true, uniqueness: { scope: :list_id, case_sensitive: false }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  scope :done, -> { where(done: true) }
  scope :not_done, -> { where(done: false) }

  def price_user_currency
    if price && list.currency && (list.currency != list.user.currency)
      sum_in_cents = price.to_f * 100
      money = Money.new(sum_in_cents, list.currency)
      money.exchange_to(list.user.currency).to_f
    else
      price.to_f
    end
  end

  protected

    def set_category
      self.category = Category.find_or_create_by!(name: 'Miscellaneous', user: self.list.user)
    end

end