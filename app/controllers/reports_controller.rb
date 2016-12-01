class ReportsController < ApplicationController
  require 'money'
  require 'money/bank/google_currency'
  # include ActionView::Helpers::NumberHelper
  # respond_to :html, :js
  # before_action :setup_money
  def index
    session[:currency] = current_user.currency
    @cats_name_sum = Hash.new
    
    # cats_id_sum = Item.done.where("list_id IN (?)", current_user.lists.pluck(:id)).group(:category_id).sum('price')
    # cats_id = cats_id_sum.keys
    # cats = Category.find(cats_id)
    # cats_id_sum.each do |cat|
    #   name = cats.detect{|c| c.id == cat[0]}.name
    #   @cats_name_sum[name] = cat[1].to_f
    # end
    
    current_user.categories.each do |cat|
      cat_sum = 0
      cat.items.each do |item|
        cat_sum += item.price_user_currency if item.done
      end
      if cat_sum != 0
        @cats_name_sum[cat.name] = cat_sum
      end
    end

    @cats_name_sum = @cats_name_sum.sort_by {|_key, value| value}.reverse.to_h
    
    # respond_with(@cats_name_sum)
  end

  def chart_data
    # //nadji iteme za to vreme pa sortiraj po categorijama
    # //sql
    days = params[:days].to_i
    @cats_name_sum = Hash.new
    
    # cats_id_sum = Item.done.where("list_id IN (?) AND items.updated_at BETWEEN ? AND ?", current_user.lists.pluck(:id), (Time.now - days.day), Time.now).group(:category_id).sum('price')
    # cats_id = cats_id_sum.keys
    # cats = Category.find(cats_id)
    # cats_id_sum.each do |cat|
    #   name = cats.detect{|c| c.id == cat[0]}.name
    #   @cats_name_sum[name] = cat[1].to_f
    # end

    # @cats_name_sum

    #PROBLEM, ne vodimo racuna koja je valuta u pitanju, uzimamo price, koja god da je valuta, trebalo bi da se sve izracuna u valuti usera
    
    current_user.categories.each do |cat|
      cat_sum = 0
      cat.items.each do |item|
        cat_sum += item.price_user_currency if (item.done && (Time.now - days.day <= item.updated_at) && (item.updated_at <= Time.now))
      end
      if cat_sum != 0
        @cats_name_sum[cat.name] = cat_sum
      end
    end

    render json: @cats_name_sum.sort_by {|_key, value| value}.reverse.to_h.to_json
  end
end

