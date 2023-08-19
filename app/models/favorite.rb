class Favorite < ApplicationRecord
  # relationの設定
  belongs_to :user # デフォルトで入ってた
  belongs_to :article # デフォルトで入ってた
end
