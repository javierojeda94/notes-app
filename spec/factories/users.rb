FactoryGirl.define do
  factory :user do
    name 'Test 1'
    email 'test@factory.com'
    password 'Pa$$w0rd'
    password_confirmation 'Pa$$w0rd'
  end
end