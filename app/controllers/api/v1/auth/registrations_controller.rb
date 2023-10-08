# class Api::V1::Auth::RegistrationsController < ApplicationController # 元々
class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  # 空白？
  private

  # 必要だった。
  def sign_up_params
    # params.permit(:email, :password, :password_confirmation, :name)
    params.permit(:email, :password, :name) #必要最小限の情報は左記なのでこれで進める。
    # params.require(:registration).permit(:name, :email, :password, :password_confirmation) # 自分の回答
    # params.permit(:name, :email, :password, :password_confirmation) #模範回答に合わせた
  end

  # 模範回答：ついでに更新用のメソッドもオーバーライドしてる
  def account_update_params
    params.permit(:name, :email)
  end
end
