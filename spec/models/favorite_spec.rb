require 'rails_helper'
# デフォルト（何に使うかわからないので、保存＋コメントアウト）
# RSpec.describe Favorite, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

# favorite
RSpec.describe Favorite, type: :model do
  # favoriteはarticleとuserの組み合わせを登録する。
  context "articleおよびuserがわかっているとき" do
    # user = FactoryBot.create(:user) #itの外はダメ、createメソッドもダメ
    it "お気に入りに登録できる" do
      user = build(:user) #省略形
      article = build(:article) #省略形
      # user = User.create(name:"test", email: "test@email2", password: "password123", password_confirmation: "password123") #newメソッドならOK
      # article = Article.create(title:"テストタイトル",body:"テスト本文", user_id: user.id) #NG
      favorite = Favorite.new(user:user, article:article)
      # binding.pry
      # expect(article.valid?).to eq true # macherを使わない場合
      expect(favorite).to be_valid
    end
  end
  context "articleがわからないとき" do
    it "お気に入りに登録できない" do
      user = build(:user) #省略形
      article = build(:article) #省略形
      favorite = Favorite.new(user:user, article:nil)
      expect(favorite).to be_invalid
    end
  end
  context "userがわからないとき" do
    it "お気に入りに登録できない" do
      user = build(:user) #省略形
      article = build(:article) #省略形
      favorite = Favorite.new(user:nil, article:article)
      expect(favorite).to be_invalid
    end
  end
end
