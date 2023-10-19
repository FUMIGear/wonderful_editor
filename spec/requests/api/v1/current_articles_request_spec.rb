# 手動でrequestファイルを作った。
require 'rails_helper'

RSpec.describe "Api::V1::Current::Articles", type: :request do
  # index
  describe "GET /api/v1/current/articles" do
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }
    subject { get(api_v1_current_articles_path, headers: headers) } # routesでAPIを確認する。
    let!(:article1) { create(:article, updated_at: 1.days.ago, status: :published, user: current_user) }
    let!(:article2) { create(:article, updated_at: 2.days.ago, status: :draft, user: current_user) }
    let!(:article3) { create(:article, status: :published, user: current_user) }
    it "ユーザーの一覧が取得できる" do
      # binding.pry #subject前の動作を確認できる。
      subject # 上で定義したURLを実行する。
      res = JSON.parse(response.body) #JSON形式に変換（変換後は配列）
      # binding.pry #subject前の動作を確認できる。
      expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id] # Task11より公開のみ表示
      expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "status", "user"] #Task11よりstatusを追加
      expect(res[0]["user"].keys).to eq ["id", "name", "email"] #userのkeyを確認
    end
  end
end
