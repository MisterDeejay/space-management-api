FactoryBot.define do
  factory :store do
    title { Faker::Company.name }
    city { Faker::Address.city }
    street { Faker::Address.street_address }
    spaces_count { Faker::Number.between(2, 15) }
  end
end
