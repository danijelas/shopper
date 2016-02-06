FactoryGirl.define do
  factory :item do
    category
    name {Faker::Name.name}
    qty {Faker::Number.decimal(8,2)}
    unit {[ "kg", "l", "m", "pic", "something" ].sample}
    price {Faker::Number.decimal(8,2)}
    done {[true, false].sample}
    list
    # before(:create) { |item| item.currency = item.list.user.currency }
  end
end