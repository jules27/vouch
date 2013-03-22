FactoryGirl.define do
  factory :shared_friend do
    vouch_list_id 1 # should be passed in
    email         "a@example.com" # should be passed in
  end
end
