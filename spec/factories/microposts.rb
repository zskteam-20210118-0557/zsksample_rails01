FactoryBot.define do
  factory :micropost do
    association :user
    content { 'MyText' }
    user_id { 1 }
  end
end
