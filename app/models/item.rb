class Item < ActiveRecord::Base
  require 'action_view'
  include ActionView::Helpers::NumberHelper
  
  belongs_to :list
  belongs_to :category

  UNIT_TYPES = [ "kg", "l", "m", "pic", "something" ]

  validates :name, presence: true, uniqueness: { scope: :list_id, case_sensitive: false }
  # validates :unit, inclusion: UNIT_TYPES

  scope :done, -> { where(done: true) }
  scope :not_done, -> { where(done: false) }

  def item_sum
    (price && qty) ? price * qty : 0
  end

  def item_sum_user_currency
    if item_sum && list.currency && (list.currency != list.user.currency)
      sum_in_cents = item_sum.to_f * 100
      money = Money.new(sum_in_cents, list.currency)
      money.exchange_to(list.user.currency).to_f
    else
      item_sum.to_f
    end
  end

end