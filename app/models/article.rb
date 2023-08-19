class Article < ApplicationRecord
  belongs_to :user #relationの設定（デフォルトで入ってた）
  has_many :favorite, dependent: :destroy
  has_many :comment, dependent: :destroy
end
