# Feature: Navigation links
#   As a visitor or user
#   I want to see navigation links
#   So I can find home, sign in, and sign up or "home," "edit account", "sign out" and "my account"
feature 'Navigation links', :devise do

  # Scenario: View navigation links
  #   Given I am a visitor
  #   When I visit the home page
  #   Then I see "sign in" and "sign up"
  scenario 'view navigation links' do
    visit root_path
    expect(page).to have_content 'Sign in'
    expect(page).to have_content 'Sign up'
  end

  # Scenario: View navigation links
  #   Given I am signed in
  #   When I visit the home page
  #   Then I see "edit account", "sign out" and "my account"
  scenario 'view navigation links' do
    user = FactoryGirl.create(:user)
    signin(user.email, user.password)
    visit root_path
    expect(page).to have_content 'My account'
    expect(page).to have_content 'Sign out'
  end

end
