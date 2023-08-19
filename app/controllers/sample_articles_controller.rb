class SampleArticlesController < ApplicationController
  before_action :set_sample_article, only: %i[ show update destroy ]

  # GET /sample_articles
  # GET /sample_articles.json
  def index
    @sample_articles = SampleArticle.all
  end

  # GET /sample_articles/1
  # GET /sample_articles/1.json
  def show
  end

  # POST /sample_articles
  # POST /sample_articles.json
  def create
    @sample_article = SampleArticle.new(sample_article_params)

    if @sample_article.save
      render :show, status: :created, location: @sample_article
    else
      render json: @sample_article.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sample_articles/1
  # PATCH/PUT /sample_articles/1.json
  def update
    if @sample_article.update(sample_article_params)
      render :show, status: :ok, location: @sample_article
    else
      render json: @sample_article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sample_articles/1
  # DELETE /sample_articles/1.json
  def destroy
    @sample_article.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sample_article
      @sample_article = SampleArticle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sample_article_params
      params.require(:sample_article).permit(:title, :body)
    end
end
