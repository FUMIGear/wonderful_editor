# 自分の回答
# class BaseApiController < ApplicationController
# end
# 名前空間を意識した方が視認性が上がる。
# 模範回答
class Api::V1::BaseApiController < ApplicationController
  # include DeviseTokenAuth::Concerns::SetUserByToken #これを入れるとcurrent_userメソッド等が使える？→なくても使える
  # alias_method :current_user, :current_api_v1_user
  # alias_method :authenticate_user!, :authenticate_api_v1_user!
  # alias_method :user_signed_in?, :api_v1_user_signed_in?
  # Task7-5で追加／Task9-4でコメントアウト
  # def current_user
  #   # binding.pry
  #   # @current_user ||= User.find_by(id: session[:user_id]) #参考サイトのコード
  #   # @current_user = create(:user) # 違う。create(:user)はテスト内で実行する。
  #   # teki_current_user = User.first # 自分の回答
  #   @current_user ||= User.first # 模範回答（こっちに合わせる）
  # end
end
