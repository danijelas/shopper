require "rails_helper"
include Warden::Test::Helpers
Warden.test_mode!
# include ActionView::Helpers::NumberHelper

RSpec.feature 'Reports management', type: :feature do

  let(:user) { create(:user) }

  before(:each) do
    login_as(user)
  end

  after(:each) do
    Warden.test_reset!
  end

  scenario 'Show All - show report for all data' do
    visit '/reports'
    
    expect(page).to have_text('Show')
    select_period = find("select[id='period']")
    expect(select_period.value).to eq('1000')
    expect(select_period.text).to eq ('All Today Last 15 days Last Month')
    select('Today', from: 'period')

    expect(page).to have_link('Filter')
    expect(page).to have_link('Switch View')
    expect(page).to have_text('Category')
    expect(page).to have_text('Sum/Category')
  end
end