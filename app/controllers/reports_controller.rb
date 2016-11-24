class ReportsController < ApplicationController
  require 'money'
  require 'money/bank/google_currency'
  # respond_to :html, :js
  # before_action :setup_money
  def index
    @cats_name_sum = Hash.new
    current_user.categories.each do |cat|
      cat_sum = 0
      cat.items.each do |item|
        cat_sum += item.price_user_currency if item.done
      end
      @cats_name_sum[cat.name] = cat_sum
    end
    # respond_with(@cats_name_sum)
  end

  def chart_data
    # //nadji iteme za to vreme pa sortiraj po categorijama
    # //sql
    days = params[:days].to_i
    @cats_name_sum = Hash.new
    current_user.categories.each do |cat|
      cat_sum = 0
      cat.items.each do |item|
        cat_sum += item.price_user_currency if (item.done && (Time.now - days.day <= item.updated_at) && (item.updated_at <= Time.now))
      end
      @cats_name_sum[cat.name] = cat_sum
    end
    # myItems = current_user.lists.includes(:items).where(items: {done: true, updated_at: (Time.now.midnight - 30.day)..Time.now.midnight}).references(:items)
    # myItems = Item.where(list_id: current_user.lists.pluck(:id), done: true, updated_at: (Time.now.midnight - days.day)..Time.now.midnight)
    @myItems = Item.where("list_id IN (?) AND done = ? AND updated_at BETWEEN ? AND ?", current_user.lists.pluck(:id), true, (Time.now - days.day), Time.now).group(:category_id)
    # binding.pry
    # # onda sve te iteme sortiras po categoriji pa nadjes sumu u svakoj???
    render json: @cats_name_sum.to_json
  end
end

