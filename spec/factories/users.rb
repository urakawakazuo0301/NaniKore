FactoryBot.define do
  factory :user do
    nickname              { Faker::Name.unique.name }
    email                 { Faker::Internet.unique.email }
    password              { '1a' + Faker::Internet.unique.password(min_length: 6) }
    password_confirmation { password }
  end
end
