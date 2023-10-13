# class Api::V1::ArticlesController < ApplicationController
class Api::V1::ArticlesController < Api::V1::BaseApiController
  before_action :set_article, only: %i[ show update destroy ]
  # before_action :authenticate_user!, except: [:index,:show] #Task9-4で追加
  before_action :authenticate_api_v1_user!, except: [:index,:show] #Task9-4で追加
  # before_action :current_user
  # before_action :set_article, only: %i[ update destroy ]

  # とりあえずsample_articleの中身をコピペした。

  # GET /articles
  # GET /articles.json
  def index
    # @articles = Article.all # 記事を全部取得
    # articles = Article.all.order(updated_at: :desc) # 更新日（昇順）に並べる
    articles = Article.where(status: "published").order(updated_at: :desc) # 更新日（昇順）に並べる
    # binding.pry
    # render json: @articles, each_serializer: ArticlesSerializer
    render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
  end

  # GET api/v1/articles/1
  # GET api/v1/articles/1.json
  def show
    # prtivateメソッドのset_articleメソッドが動いて、@article変数が使えるようになる。
    # article = Article.find(params[:id])
    # binding.pry # @articleにデータが入っているか確認
    # render json: article_show, each_serializer: Api::V1::ArticlePreviewSerializer
    render json: @article, serializer: Api::V1::ArticlePreviewSerializer
  end

  # POST api/v1/articles
  # POST api/v1/articles.json
  def create
    # binding.pry # パラメータ確認
    # @article = Article.new(article_params) #userとの紐付けがない
    # @article.user = current_user #作ったarticleのuserをcurrent_userにする（強引だが設定できた）
    # binding.pry
    # @article = current_user.article.new(article_params) #上の２行を同時に実行してみた。
    # binding.pry
    # article = current_user.article.create(article_params) #ルーティングが設定されていれば、createメソッドは使える。
    article = current_api_v1_user.article.create(article_params) #Task9-5で変更
    # @article2 = Article.new(article_params, user:current_user) #new→saveメソッドで作ってもいいが、結果的に意味がない。
    # @article2.save
    # binding.pry # 記事ができているか確認
    render json: article, serializer: Api::V1::ArticlePreviewSerializer
    # ↓いらなかった↓
    # if @article.save
    #   render :show, status: :created, location: @article
    # else
    #   render json: @article.errors, status: :unprocessable_entity
    # end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    # binding.pry # パラメータ確認
    # article = current_user.article.find(params[:id])
    article = current_api_v1_user.article.find(params[:id])
    # Article.find(params[:id]) #これで特定の記事を取得できる。
    # current_userが作成したArticle.find(params[:id])であれば表示される。
    # 違った場合、ActiveRecord::RecordNotFoundというエラーが発生する。
    # if article.user_id == current_user.id #ユーザ確認。
    if article.user_id == current_api_v1_user.id #ユーザ確認。
      # binding.pry
      article.update(article_params)
      # @article.update(article_params) #別に@
      render json: article, serializer: Api::V1::ArticlePreviewSerializer
    end
    # 案の定いらなかった
      #   render :show, status: :ok, location: @article
      # else
      #   render json: @article.errors, status: :unprocessable_entity
      # end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  # ほぼupdateのコピペ
  def destroy
    # binding.pry
    # article = current_user.article.find(params[:id])
    article = current_api_v1_user.article.find(params[:id])
    if article.user_id == current_api_v1_user.id #ユーザ確認。
    # if article.user_id == current_api_v1_user.id #ユーザ確認。
      # binding.pry
      article.destroy
      # binding.pry
      # render json: article, serializer: Api::V1::ArticlePreviewSerializer
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      # binding.pry
      # params.require(:article).permit(:title, :body)
      params.require(:article).permit(:title, :body, :status) #Task12よりstatusを追加
      # params.require(:article).permit(:title, :body, :user)
    end
end
