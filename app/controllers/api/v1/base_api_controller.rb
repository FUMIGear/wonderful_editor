# 自分の回答
# class BaseApiController < ApplicationController
# end
# 名前空間を意識した方が視認性が上がる。

# 模範回答
class Api::V1::BaseApiController < ApplicationController
  # Task7-5で追加
  def current_user
    # @current_user ||= User.find_by(id: session[:user_id])
    # binding.pry
    @current_user ||= User.first

    # @current_user = User.first
    # @current_user = create(:user)
  end
end
