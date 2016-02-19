class ItemsController < ApplicationController
  before_action :set_list
  before_action :set_item, except: [:new, :create]
  # before_action :create_category, only: :create
  before_action :get_items_for_selected_category, only: [:edit, :update, :create, :undone, :save_done, :show_confirm_done]

  def new
    @item = @list.items.build
  end

  def create
    @item = @list.items.build(item_params)
    if @item.save
      if @item.list.items.done.count == 1
        @item.list.update_attribute(:currency, session[:currency])
      end
    else
      render 'items/create_error'
    end
  end

  def edit
    
  end
  
  def update
    if @item.update(item_params)
      if @list.items.done.count == 1
        @item.list.update_attribute(:currency, session[:currency])
      end
    else
      # render 'items/update_error'
    end
  end

  def destroy
    @item.destroy
  end

  def show_confirm_done
    
  end

  def save_done
    if @item.update(item_params)
      if @list.items.done.count == 1
        @item.list.update_attribute(:currency, session[:currency])
      end
    else
      # render 'items/save_done_error'
    end
  end

  def undone
    unless @item.update_attribute(:done, false)
      render js: "alert('Unable to toggle Done property!');"      
    end
  end

  private

    def set_list
      @list = List.find(params[:list_id])
    end

    def set_item
      @item = @list.items.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:id, :name, :qty, :unit, :price, :done, :_destroy, :category_id, :currency)
    end

    # def create_category
    #   @list_params = list_params
    #   if @list_params[:items_attributes]
    #     items_with_new_category = @list_params[:items_attributes].values.select{|item| item[:category_id].to_i == 0}
    #     category_names = items_with_new_category.map{|x| x[:category_id]}.uniq
    #     name_id = Hash.new
    #     category_names.each do |cat_name|
    #       category = Category.create(name: cat_name, user: current_user)
    #       name_id[cat_name] = category.id
    #     end
    #     @list_params[:items_attributes].each do |key, item|
    #       item[:category_id] = name_id[item[:category_id]] if item[:category_id].to_i == 0
    #     end
    #   end
    # end

    def get_items_for_selected_category
      category_id = if params[:list] && params[:list][:items_attributes] && params[:list][:items_attributes]['0'] && params[:list][:items_attributes]['0'][:category_id]
                      params[:list][:items_attributes]['0'][:category_id].to_i
                    elsif params[:category_id]
                      params[:category_id].to_i
                    else
                      params[:category].to_i
                    end
      @items_for_selected_category = category_id == 0 ? @list.items.done : @list.items.done.where(category: category_id)
    end

end
