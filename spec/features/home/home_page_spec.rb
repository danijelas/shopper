# Feature: Home page
#   As a visitor
#   I want to visit a home page
#   So I can learn more about the website
feature 'Home page' do

  # Scenario: Visit the home page
  #   Given I am a visitor
  #   When I visit the home page
  #   Then I see "Image"
  #   Then I see "Welcome"
  #   Then I see "Users link"
  #   Then I see "How many users are registered"
  #   When I click on link Users
  #   Then I see "You need to sign in or sign up before continuing."
  #   Then I see "Sign in"
  #   Then I see "Email"
  #   Then I see "Sign up"
  #   Then I see "Password"
  #   Then I see "Forgot password?"
  #   Then I see "Remember me"
  scenario 'visit the home page' do
    visit root_path
    expect(page).to have_css("img[src*='cica.png']")
    expect(page).to have_content 'Welcome'
  end

end
