class CategoriesController < ApplicationController
  before_action :set_list, except: [:index, :new, :create]
  respond_to :html, :js

  def index
    @categories = current_user.categories.order(:id)
    # respond_with(@categories)
  end

  def new
    @category = current_user.categories.build
  end

  def edit

  end

  def create
    @category = current_user.categories.build(category_params)
    unless @category.save
      render 'categories/create_error'
    end
  end

  def update
    unless @category.update(category_params)
      render 'categories/update_error'
    end
  end

  def destroy
    @category.destroy
  end

  private
    
    def set_list
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end
end
