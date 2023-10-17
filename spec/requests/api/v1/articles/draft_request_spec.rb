# 手動でrequestファイルを作った。
require 'rails_helper'

# RSpec.describe "Api::V1::Articles", type: :request do
RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  # index
  describe "GET /api/v1/articles/drafts" do
    # subject { get(api_v1_articles_drafts_path) } # routesでAPIを確認する。
    subject { get(api_v1_drafts_path) } # routesでAPIを確認する。
    let!(:article1) { create(:article, updated_at: 1.days.ago, status: :published) }
    let!(:article2) { create(:article, updated_at: 2.days.ago, status: :draft) }
    let!(:article3) { create(:article, status: :published) }
    it "ユーザーの一覧が取得できる" do
      # binding.pry #subject前の動作を確認できる。
      subject # 上で定義したURLを実行する。
      res = JSON.parse(response.body) #JSON形式に変換（変換後は配列）
      # binding.pry #subject前の動作を確認できる。
      expect(res.map {|d| d["id"] }).to eq [article2.id] # Task11より公開のみ表示
      expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "status", "user"] #Task11よりstatusを追加
      expect(res[0]["user"].keys).to eq ["id", "name", "email"] #userのkeyを確認
    end
  end

  # SHOW
  # 正常系
  describe "GET /api/v1/articles/drafts/:id" do
    # subject { get(api_v1_article_drafts_path(article_id)) } #あえて存在しないarticle_idを指定するため、article_idを変数にした。
    subject { get(api_v1_draft_path(article_id)) } #あえて存在しないarticle_idを指定するため、article_idを変数にした。
    context "指定したidの記事が存在する場合" do
      let(:article) { create(:article, :draft) } #Factorybotでarticle作成
      let(:article_id) { article.id } #異常系のテストをするため、このような処置
      it "記事の詳細を取得できる" do
        # binding.pry #letの変数がおかしくなってないか確認
        subject #URIを実行
        res = JSON.parse(response.body) #結果をres変数に入れる
        # binding.pry #resの内容を確認し、テストの結果を作る
        expect(response).to have_http_status(200) #200ステータスか確認
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["user"]["id"]).to eq article.user.id
        expect(res["user"].keys).to eq ["id", "name", "email"]
      end
    end

    # 異常系：指定したIDが公開設定だった場合→
    context "指定したidが公開設定だった場合" do
      let(:article) { create(:article, :published) } #Factorybotでarticle作成
      let(:article_id) { article.id } #異常系のテストをするため、このような処置
      it "記事が見つからない" do
        # binding.pry #article_idが10000になっているか、expect文が合っているか確認
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
        # subject # showメソッドを実行したらどんなエラーが発生するか確認する。
        # # binding.pry
        # res = JSON.parse(response.body)
        # expect(res).to be_blank
      end
    end
    # 異常系：指定したidの記事が存在しない
    context "指定したidの記事が存在しない場合" do
      let(:article) { create(:article, :draft) }
      let(:article_id) { 100000 } #subjectのarticle_idを適当な数字にする。
      it "記事が見つからない" do
        # binding.pry #article_idが10000になっているか、expect文が合っているか確認
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
        # subject # showメソッドを実行したらどんなエラーが発生するか確認する。
        # binding.pry #article_idが10000になっているか、expect文が合っているか確認
        # res = JSON.parse(response.body)
        # expect(res).to be_blank
      end
    end
  end
end
