FactoryBot.define do
  # factory :article do
  #   title { "MyString" }
  #   body { "MyText" }
  #   # user { user }
  #   # user { 1 }
  # end
  factory :article do
    sequence(:title) {|n| "#{n}_#{Faker::Lorem.sentence(word_count: 5)}" }
    # sequence(:title) { Faker::Lorem.characters(number: Random.new.rand(1..20)) }
    body {Faker::Lorem.paragraph(sentence_count: 6)}
    user
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
