FactoryGirl.define do
  factory :item do
    category
    name {Faker::Name.name}
    description {Faker::Lorem.sentence}
    price {Faker::Number.decimal(8,2)}
    done {[true, false].sample}
    list
    # before(:create) { |item| item.currency = item.list.user.currency }
  end
end