FactoryBot.define do
  factory :space do
    sequence(:title) { |n| Faker::App.name << n }
    size { BigDecimal.new(Faker::Number.decimal(2)) }

    price_per_day = BigDecimal.new(Faker::Commerce.price(10.0..100.0, true))
    price_per_week = price_per_day * 6
    price_per_month = price_per_day * 28
    price_per_day { price_per_day }
    price_per_week { price_per_week }
    price_per_month { price_per_month }
  end
end
