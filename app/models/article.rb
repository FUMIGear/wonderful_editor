class Article < ApplicationRecord
  belongs_to :user #relationの設定（デフォルトで入ってた）
  has_many :favorite, dependent: :destroy
  has_many :comment, dependent: :destroy
  validates :title, presence: true
  validates :body, presence: true
  # Task12でカラム追加とenum実装
  # enum status: { private:0, public:1}, _prefix: true #defaultはprivateにしよう
  # enum status: { 0:"private", 1:"public"}, _prefix: true #エラーになる。
  enum status: { draft: "draft", published: "published" } #模範回答

end
