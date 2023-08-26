# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models # エラー対処
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  #relationの設定
  has_many :article, dependent: :destroy
  has_many :favorite, dependent: :destroy
  has_many :comment, dependent: :destroy

  # favoriteとcommentを中間テーブルとして設定
  # has_many:articles, through: :favorite
  # has_many:articles, through: :comment

  # Task6-3の模範回答
  validates :name, presence: true

end
