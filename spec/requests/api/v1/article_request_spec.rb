require 'rails_helper'

# RSpec.describe "Api::V1::Articles", type: :request do
RSpec.describe "api::v1::Articles", type: :request do
  # index
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) } # routesでAPIを確認する。
    # subject { get(articles_v1_api_path) } #違う。シンプルにフォルダの階層で考える。
    # before { create_list(:article, 3) } # FactoryBotのメソッドを使って表現した場合 #同時に３つ作れる。
    # Task7-3：模範回答（更新日をずらして、create）
    let!(:article1) { create(:article, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, updated_at: 2.days.ago) }
    let!(:article3) { create(:article) }
    it "ユーザーの一覧が取得できる" do
      # binding.pry #subject前の動作を確認できる。
      subject # 上で定義したURLを実行する。
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

  # SHOW
  describe "GET /api/v1/article/:id" do
    # subject { get(api_v1_article_path(article.id)) } #正常系のみならこれでよかった。
    subject { get(api_v1_article_path(article_id)) } #あえて存在しないarticle_idを指定するため、article_idを変数にした。
    context "指定したidの記事が存在する場合" do
      let(:article) { create(:article) } #Factorybotでarticle作成
      let(:article_id) { article.id } #異常系のテストをするため、このような処置
      # binding.pry #articleが問題なくできているか確認、contextの中に書くとindexのテスト前にbinding.pryが動いてしまう。
      it "記事の詳細を取得できる" do
        # binding.pry #letの変数がおかしくなってないか確認
        subject #URIを実行
        res = JSON.parse(response.body) #結果をres変数に入れる
        # binding.pry #resの内容を確認し、テストの結果を作る
        expect(response).to have_http_status(200) #200ステータスか確認
        # 模範回答（全部のkeyを見てるね）
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
      let(:article_id) { 100000 } #subjectのarticle_idを適当な数字にする。
      it "記事が見つからない" do
        # binding.pry #article_idが10000になっているか、expect文が合っているか確認
        # subject # showメソッドを実行したらどんなエラーが発生するか確認する。
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  # create
  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params, headers: header)}
    let(:params) { {article: attributes_for(:article)}} #ここを分解しないといけない？
    # let(:user) { create(:user) } #ユーザが必須。変数はいらないかも
    let(:current_user) { create(:user) } #ユーザが必須。変数はいらないかも
    # Task9-4で追加（headers情報を渡す）
    # let(:header_h) { current_user.create_new_auth_token  } #これでuserからheader情報入手
    # let(:header) { header_h.to_json} #ユーザ情報をjson形式に変換
    let(:header) { current_user.create_new_auth_token  } #データの渡し方にしていなければ、これでいい
    # 正常系
    context "タイトルおよび本文にデータがあり、ログインしている時" do
      it "記事が作成される" do
        # binding.pry #letがちゃんと実行されているか。
        # allow_any_instance_of(User).to receive(:current_user).and_return(user)
        # allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) #Task9-4よりコメントアウトした。
        # expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1) #模範回答
        subject #まずはこれと、responseの中身を見てからテスト結果を考えよ。
        # expect { subject }.to change { Article.count }.by(1) #違う。困ったら、subjectを実行して、レスポンスチェック。
        # binding.pry
        puts response.status
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(res["user"]["id"]).to eq current_user.id
        # expect(res["user"]["id"]).to eq article.user.id # そもそもarticleないじゃん
        expect(res["user"].keys).to eq ["id", "name", "email"]
        expect(response).to have_http_status(200)
      end
    end
    # 異常系
    # 下記の異常系を考えたが、そもそもバリデーションエラーが発生するため、createの異常系テストが思いつかなかった。
    # context "titleに文字列が入っていないとき" do
    #   it "記事の作成に失敗する" do
    # context "bodyに文字列が入っていないとき" do
    #   it "記事の作成に失敗する" do
    # context "userログインしていないとき" do
  end

  # updateメソッド／hello_world_railsのuserからコピペ
  describe "PATCH api/v1/articles/:id" do #update
    subject { patch(api_v1_article_path(article.id), params: params, headers: header) } #Task9-5でheader情報追記
    let(:current_user) { create(:user) }
    # まずは記事を作る→異常系をテストする際にcontext内に移した。
    # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) } #Task9-5で不要
    # 変更するタイトルと本文を送る。
    # let(:params) { { article: { title: "fff", body: "test" } } } #上はfactoriebotで作った値。これは手動
    # let(:params) { attributes_for(:article, title: 'other') } #この書き方でもいい。
    # let(:params) { article(title:"test") } #書き方が違う
    # let(:article) { create(:article) } #current_userのidと異なる。
    # let(:article_id) { article.id } #article.idに関するテストをしなければ不要→結果不要
    let(:params) { { article: attributes_for(:article) } }
    # userがnilなら、current_userはUser.fastになる。（current_userが指定されてれば実行しても意味がない。）
    # Task9-5でheader情報を追記
    let(:header) { current_user.create_new_auth_token  }
    context "ログインしていて、自分の作った記事の場合" do
      let(:article) { create(:article, user:current_user)}
      it '記事を編集できること' do
        # binding.pry #letで定義した変数の確認
        subject
        # binding.pry #結果を確認
        # puts response.status
        res = JSON.parse(response.body) #response確認のため
        # binding.pry # テストの条件を考えるため
        expect(response).to have_http_status(:ok) #正常に実行できた場合
        # 日本語で考える。
          # articleとresのタイトルと本文が違う。（タイトルと本文で別々に判断するから、２つ）
          # paramsとresのタイトルと本文が同じ。
        # rspecコードに変換する
          expect(res["title"]).to eq params[:article][:title]
          expect(res["body"]).to eq params[:article][:body]
          expect(res["title"]).not_to eq article.title
          expect(res["body"]).not_to eq article.body
        # 模範回答
          # expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
          #   change { article.reload.body }.from(article.body).to(params[:article][:body])
      end
    end
    context "自分が所持していない記事のレコードを更新しようとするとき" do
      # 別のユーザが作った記事をcurrent_userが更新しようとする
      let(:other_user) { create(:user) }
      let(:article) { create(:article, user: other_user) } #paramsで送るのはarticle変数
      # let(:params) { { article: attributes_for(:article) } }
      it "更新できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        # エラーをテストする場合、subjectとエラー判断を一緒に行わないといけない。
        # subjectを実行した時点でエラーになる。
          # subject
          # binding.pry
          # res = JSON.parse(response.body)
      end
    end
  end

  # destroy
  # hellow_world_railsのuser_specから拝借
  describe "DELETE api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article.id), headers:header)} #Task9-5でheaders情報を追記
    let(:current_user) { create(:user) }
    # Task9-5でheader情報を追記／ダミーメソッドをコメントアウト
    # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }
    let(:header) { current_user.create_new_auth_token  }
    context "自分が所持している記事のレコードを削除しようとするとき" do
      let(:article) { create(:article, user: current_user)}
      it "自分で作った記事を削除できる" do
        # binding.pry
        # 自分の回答
          # subject
          # binding.pry
          # res = JSON.parse(response.body) #articleの値が返ってきたけど使わない
          # expect(response).to have_http_status(:ok) #trueは出る。
        # 模範回答
          expect { subject }.to change { Article.count }.by(0)
          expect(response).to have_http_status(:no_content)
      end
    end
    context "自分が所持していない記事のレコードを削除しようとするとき" do
      let(:other_user) { create(:user) }
      let(:article) { create(:article, user: other_user)}
      it "削除に失敗する" do
        # binding.pry
        # subject
        # binding.pry
        # 自分の回答
          # expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        # 模範回答
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
          change { Article.count }.by(1)
      end
    end
  end

end
