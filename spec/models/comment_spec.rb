require 'rails_helper'

# RSpec.describe Comment, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

# Coomentのテスト
RSpec.describe Comment, type: :model do
  # Commentはbodyとuserとarticleの組み合わせを登録する。
  # favoriteにbody要素を足しただけかな。
  context "body、articleおよびuserがわかっているとき" do
    it "コメントを登録できる" do
      user = build(:user) #省略形
      article = build(:article) #省略形
      # binding.pry
      comment = Comment.new(body:"テストコメント", user:user, article:article)
      expect(comment).to be_valid
    end
  end
  context "bodyがない時" do
    it "コメントを登録できない" do
      user = build(:user) #省略形
      article = build(:article) #省略形
      comment = Comment.new(body:nil, user:user, article:article)
      # binding.pry
      expect(comment).to be_invalid
    end
  end
  context "userがない時" do
    it "コメントを登録できない" do
      user = build(:user) #省略形
      article = build(:article) #省略形
      comment = Comment.new(body:"テストコメント", user:nil, article:article)
      # binding.pry
      expect(comment).to be_invalid
    end
  end
  context "articleがない時" do
    it "コメントを登録できない" do
      user = build(:user) #省略形
      article = build(:article) #省略形
      comment = Comment.new(body:"テストコメント", user:user, article:nil)
      # binding.pry
      expect(comment).to be_invalid
    end
  end
end
