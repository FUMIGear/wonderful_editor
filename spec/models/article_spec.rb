require 'rails_helper'
# デフォルト（よくわからないからコメントアウトした）
# RSpec.describe Article, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

# articleのテスト
RSpec.describe Article, type: :model do
	context "titleおよびbodyに文字列が入っているとき" do
    # user = FactoryBot.create(:user) #itの外はダメ、createメソッドもダメ
    it "記事が作られる" do
      user = build(:user) #省略形
      # user = User.create(name:"test", email: "test@email2", password: "password123", password_confirmation: "password123") #newメソッドならOK
			# article = Article.create(title:"テストタイトル",body:"テスト本文", user_id: user.id) #NG
			article = Article.new(title:"テストタイトル",body:"テスト本文", user:user)
      # binding.pry
			# expect(article.valid?).to eq true # macherを使わない場合
			expect(article).to be_valid
    end
  end

  context "titleに文字列が入ってないとき" do
    it "記事の作成に失敗する" do
      user = FactoryBot.build(:user)
      article = Article.new(title:"",body:"テスト本文", user:user)
      expect(article).to be_invalid
    end
  end

  context "bodyに文字列が入ってないとき" do
    it "記事の作成に失敗する" do
      user = FactoryBot.build(:user)
			article = Article.new(title:"テストタイトル",body:"", user:user)
			expect(article).to be_invalid
    end
  end


  context "ユーザを指定していない時とき" do
    it "記事の作成に失敗する" do
      user = FactoryBot.build(:user)
			article = Article.new(title:"テストタイトル",body:"テスト本文", user:nil)
			expect(article).to be_invalid
    end
  end
end
