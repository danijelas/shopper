class CreateAdminService
  def call
    user = User.find_or_create_by!(email: Rails.application.secrets.admin_email) do |user|
        user.password = Rails.application.secrets.admin_password
        user.password_confirmation = Rails.application.secrets.admin_password
        user.first_name = 'admin'
        user.last_name = 'admin'
        user.currency = 'EUR'
      end
  end
end
