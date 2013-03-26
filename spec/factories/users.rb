FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |n| "Test#{n}" }
    sequence(:last_name)  { |n| "User#{n}" }
    email    { |u| "#{u.first_name}.#{u.last_name}@example.com" }
    password "password"
    password_confirmation { |u| u.password }
    city_id  { City.all.sample(1).first.id }
    admin false
  end
end
