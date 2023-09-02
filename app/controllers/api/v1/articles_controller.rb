class Api::V1::ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show update destroy ]
  # before_action :set_article, only: %i[ update destroy ]

  # とりあえずsample_articleの中身をコピペした。

  # GET /articles
  # GET /articles.json
  def index
    # @articles = Article.all # 記事を全部取得
    articles = Article.all.order(updated_at: :desc) # 更新日（昇順）に並べる
    # binding.pry
    # render json: @articles, each_serializer: ArticlesSerializer
    render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    # article = Article.find(params[:id])
    # binding.pry
    # render json: article_show, each_serializer: Api::V1::ArticlePreviewSerializer
    render json: @article, serializer: Api::V1::ArticlePreviewSerializer
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)

    if @article.save
      render :show, status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    if @article.update(article_params)
      render :show, status: :ok, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :body)
    end
end
