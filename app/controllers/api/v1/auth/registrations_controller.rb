# class Api::V1::Auth::RegistrationsController < ApplicationController # 元々
class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  # 空白？
  private

  # 必要だった。
  def sign_up_params
    # params.permit(:email, :password, :password_confirmation, :name)
    params.require(:registration).permit(:name, :email, :password, :password_confirmation)
    # params.permit(:email, :password, :name)
  end
end
