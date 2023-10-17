require 'rails_helper'

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  # 新規登録
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
        # binding.pry # パラメータ確認
        # expect { subject }.to change { Article.count }.by(1) # 別にここまで考えなくていいと思ってる。
        subject #まずはこれと完了ステータスの確認、responseの中身を見てからテスト結果を考えよ。
        # binding.pry # 実行結果確認
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

  # サインイン
  describe "POST /api/v1/auth/sign_in" do #headerとsubjectは変わらない。
    # subject { post(api_v1_user_registration_sign_in_path, params: params, headers: headers)}
    # subject { post 'api/v1/user/registration/sign_in_path', params: params, headers: headers }
    # subject { post 'http://localhost:3000/api/v1/user/registration/sign_in_path', params: params, headers: headers }
    # subject { post(api_v1_auth_sign_in_path, params: params, headers: headers)}
    subject { post(api_v1_user_session_path, params: params, headers: headers)} #ChatGPTに聞いたAPI
    let(:headers) { {"Content-Type": "application/json"} }
    let(:user) { create(:user) } # これでuserを作って、この情報をもとにAPIを叩く。
    # 正常系
    context "ユーザが存在する場合、ログインできる" do
      # let(:params_h) { attributes_for(:user)} #ユーザをハッシュで作成（テストで使う）
      let(:params_h) { {"email": user.email, "password": user.password} }#これでuserから
      let(:params) { params_h.to_json} #ユーザ情報をjson形式に変換
      it "ログインできる" do
        # binding.pry # パラメータ確認
        subject #まずはこれと完了ステータスの確認、responseの中身を見てからテスト結果を考えよ。
        # binding.pry # 実行結果確認
        # puts(response.status) #binding.pryやステータス確認で
        res_body = JSON.parse(response.body) #bodyがjson形式なので、ハッシュ形式にした。
        res_head = response.headers #headerのuidがメルアドぽかったので、
        # binding.pry
        # 今回は作ったuserと一致するようにした。
        expect(res_body["data"]["name"]).to eq user.name
        expect(res_head["uid"]).to eq user.email
        expect(response.status).to eq(200)
      end
    end
    # 異常系
    context "emailが違う" do
      let(:params_h) { {"email": "テスト", "password": user.password} }#これでuserから
      let(:params) { params_h.to_json} #ユーザ情報をjson形式に変換
      it "ログインに失敗する" do
        # binding.pry # パラメータ確認
        subject #まずはこれと完了ステータスの確認、responseの中身を見てからテスト結果を考えよ。
        # binding.pry # 実行結果確認
        # puts(response.status) #binding.pryやステータス確認で
        res = JSON.parse(response.body)
        # expect(res["data"]["uid"]).to be_blank #uidが何も無いこと
        expect(res["errors"]).to eq ["Invalid login credentials. Please try again."] #errorメッセージ
        expect(response.status).to eq(401) #エラーコード
      end
    end
    # 異常系：パスワードが違う場合
    context "パスワードが違う" do
      let(:params_h) { {"email": user.email, "password": nil} }#これでuserから
      let(:params) { params_h.to_json} #ユーザ情報をjson形式に変換
      it "ログインに失敗する" do
        # binding.pry # パラメータ確認
        subject #まずはこれと完了ステータスの確認、responseの中身を見てからテスト結果を考えよ。
        # binding.pry # 実行結果確認
        # puts(response.status) #binding.pryやステータス確認で
        res = JSON.parse(response.body)
        # expect(res["data"]["uid"]).to be_blank #uidが何も無いこと
        expect(res["errors"]).to eq ["Invalid login credentials. Please try again."] #errorメッセージ
        expect(response.status).to eq(401) #エラーコード
      end
    end
  end
   # サインアウト (サインインからコピペ)
   describe "DELETE /api/v1/auth/sign_out" do #headerとsubjectは変わらない。
    # subject { delete(api_v1_user_session_path, params: params, headers: headers)} #予想してたAPI
    # subject { delete(api_v1_auth_sign_out_path, params: params, headers: headers)} #ChatGPTに聞いたAPI
    subject { delete(destroy_api_v1_user_session_path, params: params, headers: headers)} # 参考サイトに載ってたAPI
    # subject { delete(destroy_api_v1_user_session_path, params: params)} # 変数headersがないとエラーになる
    let(:headers) { {"Content-Type": "application/json"} }
    let(:user) { create(:user) } # これでuserを作って、この情報をもとにAPIを叩く。
    # 正常系
    context "ユーザが存在し、ヘッダー情報があればログアウトできる" do
      let(:params_h) { user.create_new_auth_token  } #これでuserからheader情報入手
      let(:params) { params_h.to_json} #ユーザ情報をjson形式に変換
      it "ログアウトできる" do
        # binding.pry # パラメータ確認
        subject #まずはこれと完了ステータスの確認、responseの中身を見てからテスト結果を考えよ。
        # binding.pry # 実行結果確認
        res_body = JSON.parse(response.body) #bodyがjson形式なので、ハッシュ形式にした。
        res_head = response.headers #headerのuidがメルアドぽかったので、
        # binding.pry
        # puts(response.status) #binding.pryやステータス確認（ダミーみたいなもん）
        expect(response.status).to eq(200) #これだけでいい気がする（エラーが出た場合のメッセージの方が大事かな）
      end
    end

    # 異常系：存在しないヘッダー情報を送る
    context "ユーザが存在し、ヘッダー情報があればログアウトできる" do
      # Postamanで確認した必要なヘッダー情報はuid,client,access-token
      let(:params_h) { user.create_new_auth_token(uid:nil) } #uidを変更して、実行してみた。
      # let(:params_h) { user.create_new_auth_token(client:nil) } #clientを変更して、実行してみた
      # let(:params_h) { user.create_new_auth_token("access-token":nil) } #access-tokenを変更して、実行してみた
      let(:params) { params_h.to_json} #ユーザ情報をjson形式に変換
      it "ログアウトできる" do
        # binding.pry # パラメータ確認
        subject #まずはこれと完了ステータスの確認、responseの中身を見てからテスト結果を考えよ。
        # binding.pry # 実行結果確認
        res_body = JSON.parse(response.body) #bodyがjson形式なので、ハッシュ形式にした。
        res_head = response.headers #headerのuidがメルアドぽかったので、
        # binding.pry
        expect(res_body["errors"]).to eq ["User was not found or was not logged in."] #errorメッセージ
        expect(response.status).to eq(404) #エラーコード
      end
    end
  end
end
