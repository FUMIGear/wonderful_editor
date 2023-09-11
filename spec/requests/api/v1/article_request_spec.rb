require 'rails_helper'

# RSpec.describe "Api::V1::Articles", type: :request do
RSpec.describe "api::v1::Articles", type: :request do
  # index
  describe "GET /api/v1/articles" do
    # before { create_list(:article, 3) } # FactoryBotのメソッドを使って表現した場合 #同時に３つ作れる。
    # Task7-3：模範回答（更新日をずらして、create）
    let!(:article1) { create(:article, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, updated_at: 2.days.ago) }
    let!(:article3) { create(:article) }
    subject { get(api_v1_articles_path) }
    # subject { get(articles_v1_api_path) } #違う
    it "ユーザーの一覧が取得できる" do
      # binding.pry #subject前の動作を確認できる。
      subject
      res = JSON.parse(response.body) #JSON形式に変換（変換後は配列）
      # binding.pry
      # Task7-1の自分の回答（コメントアウト）
      # expect(res.length).to eq 3 #３つユーザつくったので、配列数も３つじゃないといけない
      # expect(res[0].keys).to eq ["title", "body"] #keyが合ってるかテストする
      # expect(response).to have_http_status(200) #ステータスコードが200（正常終了）かテスト

      # Task7-1の模範回答
      expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id] # 日付の順番を確認してる
      expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "user"] #keyを確認。serializerで設定した値
      # user.keyを確認してる。
      expect(res[0]["user"].keys).to eq ["id", "name", "email"] #userのkeyを確認
    end
  end

  describe "GET /api/v1/article/:id" do #show
    subject { get(api_v1_article_path(article_id)) }
    context "指定したidの記事が存在する場合" do
      let(:article) { create(:article) } #Factorybotでarticle作成
      let(:article_id) { article.id } #article_idにarticle.idを入れる。
      # binding.pry #articleが問題なくできているか確認、contextの中に書くとindexのテスト前にbinding.pryが動いてしまう。
      it "記事の詳細を取得できる" do
        # binding.pry #articleが問題なくできているか確認
        subject #URIを実行
        res = JSON.parse(response.body) #結果をres変数に入れる
        # binding.pry #articleが問題なくできているか確認
        expect(response).to have_http_status(200) #200ステータスか確認
        # 模範回答
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["user"]["id"]).to eq article.user.id
        expect(res["user"].keys).to eq ["id", "name", "email"]
        # expect(res[0].keys).to eq ["id", "title", "updated_at", "user"] #keyを確認。serializerで設定した値
        # user.keyを確認してる。
        # expect(res[0]["user"].keys).to eq ["id", "name", "email"] #userのkeyを確認
      end
    end
    context "指定したidの記事が存在しない場合" do
      let(:article_id) { 100000 }
      it "記事が見つからない" do
        # binding.pry #article_idが10000になっているか、expect文が合っているか確認
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  # create
  describe "POST /api/v1/articles" do
    subject {  post(api_v1_articles_path, params: params)}
    # let(:user) { create(:user) } #ユーザが必須。変数はいらないかも
    # 正常系
    let(:params) { {article: attributes_for(:article)}} #ここを分解しないといけない？
    let(:current_user) { create(:user) } #ユーザが必須。変数はいらないかも
    context "タイトルおよび本文にデータがあり、ログインしている時" do
      # binding.pry
      it "記事が作成される" do
        binding.pry
        # allow_any_instance_of(User).to receive(:current_user).and_return(user)
        allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user)
        # expect { subject }.to change { Article.count }.by(1)
        expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
        res = JSON.parse(response.body)
        binding.pry
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        # expect(res["user"]["id"]).to eq article.user.id
        expect(res["user"]["id"]).to eq current_user.id
        expect(res["user"].keys).to eq ["id", "name", "email"]
        expect(response).to have_http_status(200)
      end
    end
    # 異常系
    # context "titleに文字列が入っていないとき" do
    #   it "記事の作成に失敗する" do
    #     binding.pry
    #     params[:article][:title] = nil
    #     # expect { subject }.to raise_error(ActionController::ParameterMissing)
    #     # expect { subject }.to change { Article.count }.by(1)
    #     expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
    #     res = JSON.parse(response.body)
    #     binding.pry
    #     expect { subject }.to raise_error(ActionController::ParameterMissing)
    #   end
    # end
    # context "bodyに文字列が入っていないとき" do
    #   let(:params) { attributes_for(:user) }
    #   it "記事の作成に失敗する" do
    #     expect { subject }.to change { Article.count }.by(1)
    #     binding.pry
    #     expect { subject }.to raise_error(ActionController::ParameterMissing)
    #     res = JSON.parse(response.body)
    #     binding.pry
    #     expect(res["title"]).to eq params[:article][:title]
    #   end
    # end
    # context "userログインしていないとき" do
    #   let(:params) { attributes_for(:user) }
    #   it "記事の作成に失敗する" do
    #     # expect { subject }.to raise_error(ActionController::ParameterMissing)
    #   end
    # end
  end

end
