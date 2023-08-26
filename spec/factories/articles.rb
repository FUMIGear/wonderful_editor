FactoryBot.define do
  factory :article do
    title { "MyString" }
    body { "MyText" }
    # user { user }
    # user { 1 }
  end
  # factory :user do
  #   name { "testname" }
  #   email { "test@email23" }
  #   password { "password123" }
  #   password_confirmation { "password123" }
  #   # user { nil }
  #   # user { 1 }
  # end
end
# User.create!(name:"test", email: '', password: 'password123', password_confirmation: 'password123')
