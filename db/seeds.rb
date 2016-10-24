# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email

user1 = User.create!(first_name: 'testFirstName', last_name: 'testLastName', currency: 'RSD', email: 'testEmail@test.test', password: 'test', password_confirmation: 'test')
list1 = user1.lists.create(name: 'firstList')
list2 = user1.lists.create(name: 'secondList')
list3 = user1.lists.create(name: 'thirdList')
item1 = list1.items.create(category: user1.categories[0], name: 'milk', qty: '1', unit: user1.units[1], price: '100.00', done: false)
item2 = list1.items.create(category: user1.categories[0], name: 'cheese', qty: '2', unit: user1.units[0], price: '500.00', done: false)
item3 = list1.items.create(category: user1.categories[1], name: 'bread', qty: '1', unit: user1.units[0], price: '100.00', done: false)
item4 = list1.items.create(category: user1.categories[1], name: 'precel', qty: '2', unit: user1.units[3], price: '20.00', done: false)
item5 = list1.items.create(category: user1.categories[0], name: 'kephir', qty: '2', unit: user1.units[1], price: '200', done: false)
item6 = list1.items.create(category: user1.categories[2], name: 'carot', qty: '1', unit: user1.units[0], price: '100.00', done: false)
item7 = list1.items.create(category: user1.categories[2], name: 'strawberry', qty: '2', unit: user1.units[0], price: '200.00', done: false)
item8 = list1.items.create(category: user1.categories[3], name: 'hot-dog', qty: '10', unit: user1.units[2], price: '30.00', done: false)
item9 = list1.items.create(category: user1.categories[4], name: 'fairy', qty: '1', unit: user1.units[1], price: '100.00', done: false)
item10 = list1.items.create(category: user1.categories[5], name: 'something nice', qty: '1', unit: user1.units[4], price: '10.00', done: false)
item11 = list1.items.create(category: user1.categories[0], name: 'milky way', qty: '5', unit: user1.units[2], price: '50.00', done: true)
item12 = list1.items.create(category: user1.categories[1], name: 'cake', qty: '2', unit: user1.units[3], price: '50.00', done: true)
item13 = list1.items.create(category: user1.categories[5], name: 'something else', qty: '1', unit: user1.units[4], price: '20.00', done: true)

