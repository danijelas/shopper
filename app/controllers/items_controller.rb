class ItemsController < ApplicationController
  before_action :set_list
  before_action :set_item, except: [:new, :create]
  before_action :create_category, :create_unit, only: [:create, :update, :save_done]
  before_action :get_items_for_selected_category, only: [:edit, :update, :create, :undone, :save_done, :show_confirm_done]

  def new
    # logger.debug("------ #{session[:current_category]} -------")
    @item = @list.items.build()
    @item.category_id = session[:current_category].to_i unless session[:current_category].to_i == 0
    # @item.category_id = current_user.units[0]
  end

  def create
    @item = @list.items.build(@item_params)
    # logger.debug("------ #{@item.list.user.categories[5].id} -------")
    # logger.debug("------ #{@item.category_id} -------")
    # byebug
    unless @item.category
      # @item.category_id = 12
      @item.category = current_user.categories.find_by(name: 'Miscellaneous')
      # byebug
    end

    if @item.save
      if @item.list.items.done.count == 1
        @item.list.update_attribute(:currency, session[:currency])
        @disable_currency_select = true
      end
    else
      render 'items/create_error'
    end
  end

  def edit
    
  end
  
  def update
    if @item.update(@item_params)
      if @list.items.done.count == 1
        @item.list.update_attribute(:currency, session[:currency])
      end
    else
      render 'items/update_error'
    end
  end

  def destroy
    @item.destroy
  end

  def show_confirm_done
    
  end

  def save_done
    if @item.update(@item_params)
      # byebug
      if @list.items.done.count == 1
        @list.update_attribute(:currency, session[:currency])
      end
      @disable_currency_select = true
    else
      render 'items/save_done_error'
    end
  end

  def undone
    if @item.update_attribute(:done, false)
      @disable_currency_select = true if @list.items.done.count > 0
    else
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
      params.require(:item).permit(:id, :name, :qty, :unit_id, :price, :done, :_destroy, :category_id, :currency, :description)
    end

    def create_category
      @item_params = item_params
      if @item_params[:category_id].to_i == 0
        category_name = @item_params[:category_id]
        category = Category.create(name: category_name, user: current_user)
        # logger.debug("------ #{category.id} -------")
        @item_params[:category_id] = category.id
        # logger.debug("------ #{@item_params[:category_id]} -------")
      end
    end

    def create_unit
      @item_params ||= item_params
      # byebug
      if @item_params[:unit_id].to_i == 0
        unit_name = @item_params[:unit_id]
        unit = Unit.create(name: unit_name, user: current_user)
        @item_params[:unit_id] = unit.id
      end
    end

    def get_items_for_selected_category
      category_id = if params[:category_id]
                      params[:category_id].to_i
                    else
                      params[:category].to_i
                    end
      @items_for_selected_category = category_id == 0 ? @list.items.done : @list.items.done.where(category: category_id)
    end

end
