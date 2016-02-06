require "rails_helper"
include Warden::Test::Helpers
Warden.test_mode!
include ActionView::Helpers::NumberHelper

RSpec.feature "Lists management", type: :feature do

  let(:user) { create(:user) }

  before(:each) do
    login_as(user)
  end

  after(:each) do
    Warden.test_reset!
  end

  scenario 'empty list of lists' do
    visit "/lists"
    
    expect(page).to have_text("Lists")
    expect(page).to have_link("New List")
    expect(page).not_to have_link("Edit")
    expect(page).not_to have_link("Destroy")
  end

  scenario 'not empty list of lists' do
    list = create(:list)
    user_list = create(:list, user: user)
    visit "/lists"

    expect(page).to have_text("Lists")
    expect(page).not_to have_link(list.name)
    expect(page).to have_link(user_list.name)
    expect(page).to have_link("Edit")
    expect(page).to have_link("Destroy")
    expect(page).to have_link("New List")
  end

  scenario "User creates a new list without item with corect parameters" do
    visit "/lists"
    click_link "New List"

    expect(page).to have_text("New list")
    expect(find_field("Name").value).to be_blank
    expect(page).to have_link("Add Item")
    expect(page).to have_button("Create List")
    expect(page).to have_link("Back")

    fill_in "Name", with: "My List"
    click_button "Create List"

    expect(page).to have_text("My List")
    expect(page).to have_link("Edit")
    expect(page).to have_link("Back")
  end

  scenario "User creates a new list without item with incorect parameters (name already exists)" do
    create(:list, name: "My List", user: user)

    visit "/lists"
    click_link "New List"

    fill_in "Name", with: "My List"
    click_button "Create List"

    expect(page).to have_text("Name has already been taken")
    expect(current_path).to eq(lists_path)
  end

  scenario "User creates a new list with new item with correct parameters for item", js: true do
    visit "/lists"
    click_link "New List"
    expect(page).to have_text("New list")
    expect(find_field("Name").value).to be_blank
    expect(page).to have_link("Add Item")
    expect(page).to have_button("Create List")
    expect(page).to have_link("Back")

    fill_in "Name", with: "My List"
    click_link("Add Item")

    expect(page).to have_text("Category")
    select_category = find("select[id$='_category_id']")
    expect(select_category.value).to be_blank
    expect(select_category.text).to eq ("")
    expect(page).to have_text("Name")
    expect(find_field("item-name").value).to be_blank
    expect(page).to have_text("Quantity")
    expect(page).to have_field("item-qty", with: 0.0)
    expect(page).to have_text("Unit")
    select_unit = find("select[id$='_unit']")
    expect(select_unit.value).to be_blank
    expect(select_unit.text).to eq "Select Unit kg l m pic something"
    expect(page).to have_text("Price/Unit")
    expect(page).to have_field("item-price", with: 0.00)
    expect(page).to have_link("Remove")
    
    # select_category = find("select[id$='_category_id']")
    find('div.selectize-input').click
    find('div.option', text: 'Bakery').click
    fill_in "item-name", with: "My Item"
    fill_in "item-qty", with: 1.5
    find("select[id$='_unit']").select("kg")
    fill_in "item-price", with: 2.5
    click_button "Create List"

    expect(page).to have_text("My List")
    expect(page).to have_text("Category")
    expect(page).to have_text("Bakery")
    expect(page).to have_text("Name")
    expect(page).to have_text("My Item")
    expect(page).to have_text("Quantity")
    expect(page).to have_text("1.5")
    expect(page).to have_text("Unit")
    expect(page).to have_text("kg")
    expect(page).to have_text("Price/Unit")
    expect(page).to have_text("2.5")
    expect(page).to have_text("Sum")
    expect(page).to have_text("3.75")
    expect(page).to have_field("done", with: "false")
    expect(page).to have_text("Total Sum 0.00")
    expect(page).to have_link("Edit")
    expect(page).to have_link("Back")
    
    expect(page).to have_selector("strong[id='total_sum']", text: "0.00")
    check "done"
    within('#itemModal') do
      expect(page).to have_text("My Item")
      expect(page).to have_selector(".close")
      expect(page).to have_text("Quantity")
      expect(page).to have_field("item-qty", with: number_with_precision(1.5, precision: 2))
      expect(page).to have_text("Unit")
      select_unit = find("select[id$='_unit']")
      expect(select_unit.value).to eq("kg")
      expect(page).to have_text("Price")
      expect(page).to have_field("item-price", with: number_with_precision(2.5, precision: 2))
      expect(page).to have_button("Save")
      sleep 1
      fill_in "item-qty", with: number_with_precision(2.6, precision: 2)
      find("select[id$='_unit']").select("l")
      fill_in 'item-price', with: number_with_precision(3.6, precision: 2)
      click_button "Save"
    end
    # save_and_open_screenshot
    expect(page).to have_text("My List")
    expect(page).to have_text("Category")
    expect(page).to have_text("Bakery")
    expect(page).to have_text("Name")
    expect(page).to have_text("My Item")
    expect(page).to have_text("Quantity")
    expect(page).to have_text("2.6")
    expect(page).to have_text("Unit")
    expect(page).to have_text("l")
    expect(page).to have_text("Price/Unit")
    expect(page).to have_text("3.6")
    expect(page).to have_text("Sum")
    expect(page).to have_text(9.36)
    expect(page).to have_field("done", with: "true")
    expect(page).to have_text("Total Sum 9.36")
    expect(page).to have_link("Edit")
    expect(page).to have_link("Back")
    uncheck "done"
    check "done"
    within('#itemModal') do
      expect(page).to have_text("My Item")
      expect(page).to have_selector(".close")
      expect(page).to have_field("item-qty", with: number_with_precision(2.6, precision: 2))
      select_unit = find("select[id$='_unit']")
      expect(select_unit.value).to eq("l")
      expect(page).to have_field("item-price", with: number_with_precision(3.6, precision: 2))
      expect(page).to have_button("Save")
      close = find(".close")
      #for checking if it is in modal
      expect(page).not_to have_text("Total Sum 9.36")
      close.click
    end
    #for checking if it is out of modal
    expect(page).to have_text("Total Sum 9.36")
  end

  scenario "User creates a new list with new item with incorrect parameters for item (item name already exists)", js: true do
    list = create(:list, name: "My List", user: user)
    create(:item, name: "My Item", list: list)

    visit "/lists"
    click_link "My List"

    click_link("Edit")
    click_link("Add Item")
    page.all(:fillable_field,"item-name").last.set("My Item")
    click_button "Update List"

    expect(page).to have_text("Items name has already been taken")
    
  end
    
  scenario 'User click on link "ListName" for one list withouth item for "Show"' do
    list = create(:list, user: user)
    visit "/lists"
    expect(page).to have_link(list.name)
    click_link list.name

    expect(page).to have_text(list.name)
    expect(page).to have_link("Edit")
    expect(page).to have_link("Back")
  end

  scenario 'User click on link "ListName" for one list with item for "Show"' do
    list = create(:list, user: user)
    item = create(:item, list: list, done: false)
    visit "/lists"
    expect(page).to have_link(list.name)
    click_link list.name

    expect(page).to have_text(item.list.name)
    expect(page).to have_text("Category")
    expect(page).to have_text(item.category.name)
    expect(page).to have_text("Name")
    expect(page).to have_text(item.name)
    expect(page).to have_text("Quantity")
    expect(page).to have_text(item.qty)
    expect(page).to have_text("Unit")
    expect(page).to have_text(item.unit)
    expect(page).to have_text("Price/Unit")
    expect(page).to have_text(item.price)
    expect(page).to have_text("Sum")
    expect(page).to have_text((number_with_precision(item.qty*item.price, precision: 2)))
    expect(page).to have_field("done", with: "false")
    expect(page).to have_text("Total Sum")
    expect(page).to have_text((number_with_precision(item.qty*item.price, precision: 2)))
    expect(page).to have_link("Edit")
    expect(page).to have_link("Back")
  end

  scenario 'User clicks on link "Edit" for one list without item and edits list name' do
    list = create(:list, user: user)
    visit "/lists"
    click_link "Edit"

    expect(page).to have_text("Editing list")
    expect(page).to have_text("Name")
    expect(page).to have_field("Name", with: list.name)
    expect(page).to have_link("Add Item")
    expect(page).to have_button("Update List")
    expect(page).to have_link("Show")
    expect(page).to have_link("Back")

    fill_in "Name", with: "New List Name"
    click_button "Update List"

    expect(page).to have_text("New List Name")
    expect(page).to have_link("Edit")
    expect(page).to have_link("Back")
  end

  scenario 'User clicks on link "Edit" for one list with item and edits list name and items attributes', js: true do
    list = create(:list, user: user)
    category1 = user.categories[0]
    item = create(:item, category: category1, unit: "kg", list: list, done: false)
    visit "/lists"
    click_link "Edit"

    expect(page).to have_text("Editing list")
    expect(page).to have_text("Name")
    expect(page).to have_field("list[name]", with: item.list.name)
    expect(page).to have_link("Add Item")
    expect(page).to have_text("Category")
    select_category = find("select[id$='_category_id']")
    expect(select_category.value).to eq(item.category.id.to_s)
    expect(select_category.text).to eq (item.category.name)
    expect(select_category.text).to eq ("Dairy")
    expect(page).to have_text("Name")
    expect(page).to have_field("item-name", with: item.name)
    expect(page).to have_text("Quantity")
    expect(page).to have_field("item-qty", with: number_with_precision(item.qty, precision: 2))
    expect(page).to have_text("Unit")
    select_unit = find("select[id$='_unit']")
    expect(select_unit.value).to eq("kg")
    expect(select_unit.text).to eq("kg l m pic something")
    expect(page).to have_text("Price/Unit")
    expect(page).to have_field("item-price", with: number_with_precision(item.price, precision: 2))
    expect(page).to have_link("Remove")
    expect(page).to have_button("Update List")
    expect(page).to have_link("Show")
    expect(page).to have_link("Back")

    fill_in "list[name]", with: "New List Name"
    # select_category = find("select[id$='_category_id']")
    find('div.selectize-input').click
    find('div.option', text: 'Bakery').click
    fill_in "item-name", with: "New Item Name"
    fill_in "item-qty", with: "2.5"
    find("select[id$='_unit']").select 'l'
    fill_in "item-price", with: "123.45"
    click_button "Update List"

    expect(page).to have_text("New List Name")
    expect(page).to have_text("Category")
    expect(page).to have_text("Bakery")
    expect(page).to have_text("Name")
    expect(page).to have_text("New Item Name")
    expect(page).to have_text("Quantity")
    expect(page).to have_text("2.5")
    expect(page).to have_text("Unit")
    expect(page).to have_text("l")
    expect(page).to have_text("Price/Unit")
    expect(page).to have_text("123.45")
    expect(page).to have_text("Sum")
    expect(page).to have_selector("strong[id='total_sum']", text: "0.00")
    expect(page).to have_field("done", with: "false")
    check "done"
    expect(page).to have_selector("strong[id='total_sum']", text: "308.63")
    expect(page).to have_text("Total Sum 308.63")
    expect(page).to have_link("Edit")
    expect(page).to have_link("Back")
  end

  scenario 'User clicks on link "Remove" for one item and deletes item', js: true do
    #takodje i test za category kad je custom
    list = create(:list, user: user)
    category = create(:category, user: user)
    item = create(:item, category: category, list: list)
    visit edit_list_path(list)

    expect(page).to have_text("Editing list")
    expect(page).to have_text("Name")
    expect(page).to have_field("list[name]", with: list.name)
    expect(page).to have_link("Add Item")
    expect(page).to have_text("Category")
    select_category = find("select[id$='_category_id']")
    expect(select_category.value).to eq(item.category.id.to_s)
    expect(select_category.text).to eq (item.category.name)
    expect(page).to have_text("Name")
    expect(page).to have_field("item-name", with: item.name)
    expect(page).to have_text("Quantity")
    expect(page).to have_field("item-qty", with: number_with_precision(item.qty, precision: 2))
    expect(page).to have_text("Unit")
    select_unit = find("select[id$='_unit']")
    expect(select_unit.value).to eq(item.unit)
    expect(select_unit.text).to eq("kg l m pic something")
    expect(page).to have_text("Price/Unit")
    expect(page).to have_field("item-price", with: number_with_precision(item.price, precision: 2))
    expect(page).to have_link("Remove")
    expect(page).to have_button("Update List")
    expect(page).to have_link("Show")
    expect(page).to have_link("Back")
    expect(page).to have_selector('thead')
    expect(page).not_to have_selector("thead[class='hidden']")

    click_link "Remove"

    expect(page).to have_text("Editing list")
    expect(page).to have_text("Name")
    expect(page).to have_field("list[name]", with: list.name)
    expect(page).to have_link("Add Item")
    expect(page).to have_button("Update List")
    expect(page).to have_link("Show")
    expect(page).to have_link("Back")
    input_destroy = find("input[id$='_destroy']")
    expect(input_destroy.value).to eq("1")
    expect(page).to have_selector("thead[class='hidden']")

    click_button "Update List"

    expect(page).to have_text(list.name)
    expect(page).to have_link("Edit")
    expect(page).to have_link("Back")

    click_link "Edit"

    expect(page).to have_text("Editing list")
    expect(page).to have_text("Name")
    expect(page).to have_field("list[name]", with: list.name)
    expect(page).to have_link("Add Item")
    expect(page).not_to have_selector("select[id$='_category_id']")
    expect(page).not_to have_field("item-name", with: item.name)
    expect(page).not_to have_field("item-qty", with: number_with_precision(item.qty, precision: 2))
    expect(page).not_to have_selector("select[id$='_unit']")
    expect(page).not_to have_field("item-price", with: number_with_precision(item.price, precision: 2))
    expect(page).not_to have_link("Remove")    
    expect(page).to have_button("Update List")
    expect(page).to have_link("Show")
    expect(page).to have_link("Back")
  end

  scenario 'User clicks on link "Destroy" for one list without item and deletes list' do
    list = create(:list, user: user)
    visit "/lists"

    expect(page).to have_text("Lists")
    expect(page).to have_text(list.name)
    expect(page).to have_link("Edit")
    expect(page).to have_link("Destroy")
    expect(page).to have_link("New List")

    click_link "Destroy"

    expect(page).to have_text("Lists")
    expect(page).not_to have_text(list.name)
    expect(page).not_to have_link("Edit")
    expect(page).not_to have_link("Destroy")
    expect(page).to have_link("New List")
  end

  scenario 'User clicks on link "Destroy" for one list with item and deletes list with item' do
    list = create(:list, user: user)
    item = create(:item, list: list)
    visit "/lists"

    expect(page).to have_text("Lists")
    expect(page).to have_text(item.list.name)
    expect(page).to have_link("Edit")
    expect(page).to have_link("Destroy")
    expect(page).to have_link("New List")

    click_link "Destroy"

    expect(page).to have_text("Lists")
    expect(page).not_to have_text(item.list.name)
    expect(page).not_to have_link("Edit")
    expect(page).not_to have_link("Destroy")
    expect(page).to have_link("New List")
  end

  scenario 'User clicks link back from show' do
    list = create(:list, user: user)
    item = create(:item, list: list)
    visit "/lists"
    click_link item.list.name
    click_link "Back"
    expect(current_path).to eq(lists_path)
  end

  scenario 'User clicks link edit from show' do
    list = create(:list, user: user)
    item = create(:item, list: list)
    visit "/lists"
    click_link item.list.name
    click_link "Edit"
    expect(current_path).to eq(edit_list_path(item.list))
  end

  scenario 'User clicks link back from edit' do
    list = create(:list, user: user)
    item = create(:item, list: list)
    visit "/lists"
    click_link "Edit"
    click_link "Back"
    expect(current_path).to eq(lists_path)
  end

  scenario 'User clicks link show from edit' do
    list = create(:list, user: user)
    item = create(:item, list: list)
    visit "/lists"
    click_link "Edit"
    click_link "Show"
    expect(current_path).to eq(list_path(item.list))
  end

  scenario 'User check first item as done, then second, then both which causes total sum to change', js: true do
    list = create(:list, user: user)
    item1 = create(:item, list: list, done: false, qty: 2, price: 3)
    item2 = create(:item, list: list, done: false, qty: 3, price: 4)
    visit list_path(list)
    expect(page).to have_selector("strong[id='total_sum']", text: "0.00")
    check item1.id
    click_button "Save"
    expect(page).to have_selector("strong[id='total_sum']", text: 6.00)
    uncheck item1.id
    expect(page).to have_selector("strong[id='total_sum']", text: "0.00")
    check item2.id
    click_button "Save"
    expect(page).to have_selector("strong[id='total_sum']", text: 12.00)
    check item1.id
    click_button "Save"
    expect(page).to have_selector("strong[id='total_sum']", text: 18.00)
  end

end
