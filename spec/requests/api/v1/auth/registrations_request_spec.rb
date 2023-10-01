require 'rails_helper'

# 新規登録
RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /api/v1/auth" do #headerとsubjectは変わらない。
    # subject { post(api_v1_auth_path, params: params)} # routes
    # subject { post(api_v1_auth_path, sign_up_params: params)}
    # subject { post(api_v1_auth_path, headers: headers)}
    # subject { post(api_v1_auth_path, params: user_params, headers: headers)}
    # subject { post(api_v1_user_registration_path, params: params)}
    subject { post(api_v1_user_registration_path, params: params, headers: headers)}
    # let(:headers) { attributes_for(:user)} #user版はこうか？
    # let(:user) { create(:user) } #もしくはシンプルにこうか？
    let(:headers) { {"Content-Type": "application/json"} }
    # 正常系
    context "userパラメータに名前、email、パスワードがある" do
      # let(:params) { {article: attributes_for(:article)}} #articleのcreateはこれ
      # let(:params_h) { {user: attributes_for(:user)}} #user版はこうか？
      # let(:params) { attributes_for(:user).to_json } #user版はこうか？
      # let(:params) { {user: attributes_for(:user).merge(
      # # let(:params) { attributes_for(:user).merge(
      #   password: "password", # パスワードを追加
      #   password_confirmation: "password" # パスワード確認を追加
      #   )
      # }.to_json
      # }
      # let(:params) { attributes_for(:user)} #テストでparamsをハッシュで使いたい
      let(:params_h) { attributes_for(:user)} #ユーザをハッシュで作成（テストで使う）
      let(:params) { params_h.to_json} #ユーザ情報をjson形式に変換
      it "ユーザが作成される" do
        binding.pry # パラメータ確認
        # expect { subject }.to change { Article.count }.by(1) # 別にここまで考えなくていいと思ってる。
        subject #まずはこれと完了ステータスの確認、responseの中身を見てからテスト結果を考えよ。
        binding.pry # 実行結果確認
        # puts(response.status) #binding.pryやステータス確認で
        res_body = JSON.parse(response.body) #bodyがjson形式なので、ハッシュ形式にした。
        res_head = response.headers #headerのuidがメルアドぽかったので、
        # params = JSON.parse(params) #letで宣言した変数を書き換えられない（エラーになりブランクになる）
        # binding.pry
        # expect(response).to have_http_status(200)
        expect(res_body["data"]["name"]).to eq params_h[:name]
        expect(res_body["data"]["email"]).to eq params_h[:email]
        expect(res_head["uid"]).to eq params_h[:email]
        expect(response.status).to eq(200)
      end
    end
    # 異常系
    context "userパラメータに名前だけ無い" do
      let(:params_h) { attributes_for(:user, name:nil)} #ユーザをハッシュで作成（テストで使う）
      let(:params) { params_h.to_json} #ユーザ情報をjson形式に変換
      it "ユーザの作成に失敗する" do
        # binding.pry # パラメータ確認
        subject #まずはこれと完了ステータスの確認、responseの中身を見てからテスト結果を考えよ。
        # binding.pry # 実行結果確認
        res = JSON.parse(response.body)
        # expect(res["data"]["uid"]).to eq blank
        expect(res["data"]["uid"]).to be_blank #uidが何も無いこと
        expect(response.status).to eq(422) #エラーコード
      end
    end
    context "userパラメータにemailだけ無い" do
      let(:params_h) { attributes_for(:user, email:nil)} #ユーザをハッシュで作成（テストで使う）
      let(:params) { params_h.to_json} #ユーザ情報をjson形式に変換
      it "ユーザの作成に失敗する" do
        # binding.pry # パラメータ確認
        subject #まずはこれと完了ステータスの確認、responseの中身を見てからテスト結果を考えよ。
        # binding.pry # 実行結果確認
        res = JSON.parse(response.body)
        # expect(res["data"]["uid"]).to eq blank
        expect(res["data"]["uid"]).to be_blank #uidが何も無いこと
        expect(response.status).to eq(422) #エラーコード
      end
    end
    context "userパラメータにpasswordだけ無い" do
      let(:params_h) { attributes_for(:user, password:nil)} #ユーザをハッシュで作成（テストで使う）
      let(:params) { params_h.to_json} #ユーザ情報をjson形式に変換
      it "ユーザの作成に失敗する" do
        # binding.pry # パラメータ確認
        subject #まずはこれと完了ステータスの確認、responseの中身を見てからテスト結果を考えよ。
        # binding.pry # 実行結果確認
        res = JSON.parse(response.body)
        # expect(res["data"]["uid"]).to eq blank
        expect(res["data"]["uid"]).to be_blank #uidが何も無いこと
        expect(response.status).to eq(422) #エラーコード
      end
    end
  end
end
