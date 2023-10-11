require 'rails_helper'
# デフォルト（よくわからないからコメントアウトした）
# RSpec.describe Article, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

# articleのテスト
RSpec.describe Article, type: :model do
	# context "titleおよびbodyに文字列が入っているとき" do
	context "titleおよびbodyに文字列が入っているとき下書きで保存" do #Task12で追記
    # user = FactoryBot.create(:user) #itの外はダメ、createメソッドもダメ
    # let(:user) { build(:user)} #省略形、factoriesの方でuserを作れば入らなくなる。
    # let(:article) { build(:article,user: user)} #これでもいいといえばいい。
    let(:article) { build(:article)}
    it "記事が作られる" do
      # user = User.create(name:"test", email: "test@email2", password: "password123", password_confirmation: "password123") #newメソッドならOK
			# article = Article.create(title:"テストタイトル",body:"テスト本文", user_id: user.id) #NG
      binding.pry
			# expect(article.valid?).to eq true # macherを使わない場合
			expect(article).to be_valid
      expect(article.status).to eq "private" #Task12で追加
    end
  end
  context "titleおよびbodyに文字列が入っているとき公開する" do #Task12で追記
    let(:article) { build(:article, status:1)}
    it "記事が作られる" do
      binding.pry
			expect(article).to be_valid
      expect(article.status).to eq "public"
    end
  end

  context "titleに文字列が入ってないとき" do
    let(:article) { build(:article, title:"")}
    it "記事の作成に失敗する" do
      # binding.pry
      expect(article).to be_invalid
    end
  end

  context "bodyに文字列が入ってないとき" do
    let(:article) { build(:article, body:"")}
    it "記事の作成に失敗する" do
			expect(article).to be_invalid
    end
  end

  context "ユーザを指定していない時とき" do
    let(:article) { build(:article, user:nil)}
    it "記事の作成に失敗する" do
			expect(article).to be_invalid
    end
  end
end
