class Comment < ApplicationRecord
  # relationの設定
  belongs_to :user # デフォルトで入ってた
  belongs_to :article # デフォルトで入ってた
  validates :body, presence: true
end
