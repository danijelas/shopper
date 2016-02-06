# include Warden::Test::Helpers
# Warden.test_mode!

# # Feature: User index page
# #   As a user
# #   I want to see a list of users
# #   So I can see who has registered
# feature 'User index page', :devise do

#   after(:each) do
#     Warden.test_reset!
#   end

#   # Scenario: User listed on index page
#   #   Given I am signed in
#   #   When I visit the user index page
#   #   Then I see "Users"
#   #   Then I see my own email address
#   #   Then I see my own name
#   scenario 'user sees own name and email address' do
#     user = FactoryGirl.create(:user)
#     login_as(user, scope: :user)
#     visit users_path
#     expect(page).to have_content('Users')
#     expect(page).to have_content user.email
#     expect(page).to have_content user.name
#   end

# end
