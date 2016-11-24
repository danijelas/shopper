class ListsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_list, except: [:index, :new, :create]
  # before_action :get_items_for_selected_category, only: :change_category

  respond_to :html, :js

  def index
    @lists = current_user.lists.order(:name)
  end

  def show
    session[:current_category] = 0
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
  end

  def edit

  end

  def create
    @list = current_user.lists.build(list_params)
    if @list.save
      # render js: "window.location.href='#{list_url(@list)}'"
    else
      render 'lists/create_error'
    end
  end

  def update
    unless @list.update(list_params)
      render 'lists/update_error'
    end
  end

  def destroy
    @list.destroy
  end

  def render(*args)
    set_disable_currency_select
    super
  end

  def change_category
    category_id = params[:category]
    session[:current_category] = category_id
    @done_items = category_id.to_i == 0 ? @list.items.done : @list.items.where(category_id: category_id).done
  end

  private
    
    def set_list
      @list = List.find(params[:id])
    end

    def list_params
      params.require(:list).permit(:name, :currency)
    end

    def set_disable_currency_select
      if @list
        # enable/disable currency select - top right
        @disable_currency_select = @list.items.done.count > 0 ? true : false
      end
    end

    # def get_items_for_selected_category
    #   category_id = if params[:list] && params[:list][:items_attributes] && params[:list][:items_attributes]['0'] && params[:list][:items_attributes]['0'][:category_id]
    #                   params[:list][:items_attributes]['0'][:category_id].to_i
    #                 elsif params[:category_id]
    #                   params[:category_id].to_i
    #                 else
    #                   params[:category].to_i
    #                 end
    #   @items_for_selected_category = category_id == 0 ? @list.items.done : @list.items.done.where(category: category_id)
    # end

end
