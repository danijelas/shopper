class ListsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_list, except: [:index, :new, :create]
  before_action :create_category, only: [:create, :update, :create_item]
  before_action :get_items_for_selected_category, only: [:item_undone, :change_category, :update_item, :save_item]

  respond_to :html, :js

  def index
    @lists = current_user.lists.order(:name)
    # @disable_currency_select = true
    # respond_with(@lists)
  end

  def show
    session[:currency] = @list.currency
    @items_not_done = @list.items.not_done
    @items_sorted_by_category_not_done = Hash.new
    @items_not_done.order(:category_id, :id).each do |item|
      if item.category
        if @items_sorted_by_category_not_done.key?(item.category.name)
          @items_sorted_by_category_not_done[item.category.name] << item
        else  
          @items_sorted_by_category_not_done[item.category.name] = [item]
        end
      else
        if @items_sorted_by_category_not_done.key?("Miscellaneous")
          @items_sorted_by_category_not_done["Miscellaneous"] << item
        else
          @items_sorted_by_category_not_done["Miscellaneous"] = [item]
        end
      end
    end

    @items_done = @list.items.done
    @items_sorted_by_category_done = Hash.new
    @items_done.order(:category_id, :id).each do |item|
      if item.category
        if @items_sorted_by_category_done.key?(item.category.name)
          @items_sorted_by_category_done[item.category.name] << item
        else  
          @items_sorted_by_category_done[item.category.name] = [item]
        end
      else
        if @items_sorted_by_category_done.key?("Miscellaneous")
          @items_sorted_by_category_done["Miscellaneous"] << item
        else
          @items_sorted_by_category_done["Miscellaneous"] = [item]
        end
      end
    end
  end

  def new
    @list = List.new
    # binding.pry
    # respond_with(@list)
  end

  def edit
    # @items = @list.items.order(:category_id, :id)
    
  end

  def create
    @list = current_user.lists.build(@list_params)
    if @list.save
      render js: "window.location.href='#{list_url(@list)}'"
    else
      render 'lists/create_error'
    end
  end

  def update
    @list.update(@list_params)
    # respond_with(@list)
    if @list.name
      render js: "window.location.href='#{lists_url}'"
    else
      # render 'lists/create_error'
    end
  end

  def destroy
    @list.destroy
    respond_with(@list)
  end

  def item_undone
    @item = @list.items.find_by_id(params[:item_id])
    unless @item.update_attribute(:done, false)
      render js: "alert('Unable to toggle Done property!');"      
    end
  end

  def update_item
    @item = @list.items.find_by_id(params[:item_id])
  end

  def save_item
    @list.update(list_params)
    @item_id = list_params[:items_attributes].values.first[:id]
    # binding.pry
    @item = @list.items.find_by_id(@item_id)
    if @list.items.done.count == 1
      @list.update_attribute(:currency, session[:currency])
    end
  end

  def render(*args)
    set_disable_currency_select
    super
  end

  def delete_item
    @item = @list.items.find_by_id(params[:item_id])
    @item.destroy
  end

  def create_item
    unless @list.update(@list_params)
      render js: "alert('#{@list.errors.full_messages.to_sentence}')"
    end
  end

  private
    
    def set_list
      @list = List.find(params[:id])
    end

    def list_params
      params.require(:list).permit(:name, :currency, items_attributes: [:id, :name, :qty, :unit, :price, :done, :_destroy, :category_id, :currency])
    end

    def create_category
      @list_params = list_params
      if @list_params[:items_attributes]
        items_with_new_category = @list_params[:items_attributes].values.select{|item| item[:category_id].to_i == 0}
        category_names = items_with_new_category.map{|x| x[:category_id]}.uniq
        name_id = Hash.new
        category_names.each do |cat_name|
          category = Category.create(name: cat_name, user: current_user)
          name_id[cat_name] = category.id
        end
        @list_params[:items_attributes].each do |key, item|
          item[:category_id] = name_id[item[:category_id]] if item[:category_id].to_i == 0
        end
      end
    end

    def set_disable_currency_select
      if @list
        # enable/disable currency select - top right
        @disable_currency_select = @list.items.done.count > 0 ? true : false
      end
    end

    def get_items_for_selected_category
      category_id = if params[:list] && params[:list][:items_attributes] && params[:list][:items_attributes]['0'] && params[:list][:items_attributes]['0'][:category_id]
                      params[:list][:items_attributes]['0'][:category_id].to_i
                    elsif params[:category_id]
                      params[:category_id].to_i
                    else
                      params[:category].to_i
                    end
      # binding.pry
      @items_for_selected_category = category_id == 0 ? @list.items.done : @list.items.done.where(category: category_id)
    end

end
