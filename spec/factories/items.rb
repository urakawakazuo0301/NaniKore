FactoryBot.define do
  factory :item do
    name                  { Faker::Commerce.product_name }
    category_id           { Category.where.not(id: 1).sample.id }
    quantity_id           { Quantity.where.not(id: 1).sample.id }
    color_id              { Color.all.sample.id }
    notes                 { Faker::Lorem.sentence }

    association :user

    after(:build) do |item|
      item.images.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end
