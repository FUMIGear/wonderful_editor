# 手動でcontrollerを作成した。
# class Api::V1:Artciles::DraftsController < Api::V1::ArticlesController
class Api::V1::Articles::DraftsController < Api::V1::BaseApiController
# class Api::V1::DraftsController < Api::V1::BaseApiController
# class Api::V1::Articles::DraftsController < Api::V1::ArticlesController
  # before_action :set_article, only: %i[ show update destroy ]
  # before_action :set_article, only: %i[ show ]
  # before_action :authenticate_api_v1_user!, except: [:index,:show] #Task9-4で追加
  before_action :authenticate_api_v1_user! #Task9-4で追加


  # GET api/v1/articles/draft
  def index
    # articles = Article.draft.order(updated_at: :desc) # 更新日（昇順）に並べる
    # articles = Article.where(status: "draft").order(updated_at: :desc) #自分の回答
    # binding.pry
    # articles = current_user.articles.draft.order(updated_at: :desc) #模範回答
    articles = current_api_v1_user.article.draft.order(updated_at: :desc) #模範回答に合わせた
    # binding.pry
    render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
  end

  # GET api/v1/articles/draft/:id
  def show
    # article = Article.draft.find(params[:id]) #Task11で追記
    # binding.pry
    article = current_api_v1_user.article.draft.find(params[:id]) #Task11で追記
    # binding.pry
    render json: article, serializer: Api::V1::ArticlePreviewSerializer
  end
  # private
  #   def set_article
  #     article = Article.find(params[:id])
  #   end

  #   def article_params
  #     binding.pry
  #     params.require(:article).permit(:title, :body, :status)
  #   end
end
