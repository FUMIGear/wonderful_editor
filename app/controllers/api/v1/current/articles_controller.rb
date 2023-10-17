# class Api::V1::Current::ArticlesController < Api::V1::BaseApiController
class Api::V1::Current::ArticlesController < Api::V1::ArticlesController
  before_action :authenticate_api_v1_user!

  # GET api/v1/articles/draft
  def index
    # binding.pry
    # articles = current_user.Article.order(updated_at: :desc) # current_userデータを全部。
    # articles = current_api_v1_user.Article.order(updated_at: :desc) # current_userデータを全部。
    articles = current_api_v1_user.article.order(updated_at: :desc) # current_userデータを全部。
    # binding.pry
    render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
  end
end
