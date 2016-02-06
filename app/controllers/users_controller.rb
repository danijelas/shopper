class UsersController < ApplicationController
  before_filter :authenticate_user!
  # respond_to :html, :js

  def set_currency
    session[:currency] = params[:currency]
    # binding.pry
    respond_to do |format|
      format.js { head :no_content }
    end
  end
end
