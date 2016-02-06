module ControllerMacros

  def login_user(user = FactoryGirl.create(:user))
    sign_out @user unless @user.nil?
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = user
    # @user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
    sign_in @user
  end

end
