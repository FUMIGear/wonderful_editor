FactoryBot.define do
  factory :user do
    # id { 1 } #いらない。テストの時はidは気にしない。
    name { "testname" }
    email { "test@email23" }
    password { "password123" }
    password_confirmation { "password123" }
  end
end
