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
        # binding.pry
        # allow_any_instance_of(User).to receive(:current_user).and_return(user)
        allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user)
        # expect { subject }.to change { Article.count }.by(1)
        expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
        res = JSON.parse(response.body)
        # binding.pry
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

  # updateメソッド／hello_world_railsのuserからコピペ
  describe "PATCH api/v1/articles/:id" do #update
    subject { patch(api_v1_article_path(article.id), params: params) }
    # let(:article_test){create(:article)}
    # let(:params) { { article: { title: "fff", body: "test" } } }
    # let(:user_id) { article_test.user.id }
    # let(:current_user) { create(:user) }
    # let(:article) { create(:article) }
    # let(:article_id) { article.id }
    # let!(:params) { attributes_for(:article, title: 'other') }
    # let(:params) { article.attributes }
    # let(:params) { article(title:"test") }
    # let(:params) { { article: { title:"new_title", body:article.body } } }
    let(:params) { { article: attributes_for(:article) } } #変更後

    let(:current_user) { create(:user) }
    # userがnilなら、current_userはUser.fastになる。（current_userが指定されてれば実行しても意味がない。
    before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }

    context "ログインしていて、自分の作った記事の場合" do
      let(:article) { create(:article, user: current_user) } #元々
      it '記事を編集できること' do
        # params = article(title:"new_title")
        # article.title = "test"c
        # binding.pry
        # subject #article.idを指定して、paramsのデータをupdateメソッドに送る。
        # binding.pry
        expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
        change { article.reload.body }.from(article.body).to(params[:article][:body])
        # binding.pry
        expect(response).to have_http_status(:ok)
        # allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user)
        # expect { subject }.to change { Article.find(article_id).title }.to("new_title")
        # binding.pry
        # expect { subject }.not_to change { Article.find(article_id).body }

        # expect { subject }.not_to change(Article, :count)
        # expect(response).to have_http_status(302)
        # expect(Article.reload.title).to eq 'other'
        # allow_any_instance_of(User).to receive(:current_user).and_return(user)
        # allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user)
        # expect { subject }.not_to change(Article, :count)

        # expect { subject }.to change { Article.count }.by(1)
        # expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
        # binding.pry
        # expect { subjet }を
        # expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
        # titleとbodyが変わってるかチェックしよう。
        # binding.pry
        # not_change { article.reload.title } &
        # not_change { article.reload.body }
        # not_change { article.reload.created_at }
      end
    end
    context "自分が所持していない記事のレコードを更新しようとするとき" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "更新できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  # hellow_world_railsのuser_specから拝借
  describe "DELETE api/v1/articles/:id" do #destroy
    subject { delete(api_v1_article_path(article.id))}
    before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }
    let(:current_user) { create(:user) }
    context "自分が所持している記事のレコードを削除しようとするとき" do
      let(:article) { create(:article, user: current_user)}
      it "自分で作った記事を削除できる" do
        # binding.pry
        expect { subject }.to change { Article.count }.by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end
    context "自分が所持していない記事のレコードを削除しようとするとき" do
      let(:other_user) { create(:user) }
      let(:article) { create(:article, user: other_user)}
      it "削除に失敗する" do
        # binding.pry
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        # subject
      end
    end



  end

end
