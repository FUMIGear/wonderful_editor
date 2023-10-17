class Api::V1::ArticlePreviewSerializer < ActiveModel::Serializer
  # attributes :id
  # attributes :title #articleのタイトルだけでいいと思う。→ダメだった
  # Task7-1:自分の回答（コメントアウト）
  # attributes :title, :body #articleのタイトルだけでいいと思う。
  # 模範回答／Task7-4で:bodyを追加
  # attributes :id, :title, :body, :updated_at
  attributes :id, :title, :body, :updated_at, :status # statusを追加
  belongs_to :user, serializer: Api::V1::UserSerializer
end
