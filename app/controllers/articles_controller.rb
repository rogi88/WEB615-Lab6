# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  title      :text
#  content    :text
#  category   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class ArticlesController < ApplicationController
  before_action :authenticate_user!

  # GET /articles
  # GET /articles.json
  def index
    begin
    @articles = Article.paginate(:page => params[:page], :per_page => params[:per_page] ||= 30).order(created_at: :desc)
  rescue => e
    flash[:alert] = "Something went terribly wrong"
    respond_to do |format|
      format.html{
        redirect_to articles_path
      }
      format.json {render :json, status: 418}
    end
  end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    begin
  rescue ActiveRecord::RecordNotFound => e
    flash[:alert] = "The article you're looking for cannot be found"
    respond_to do |format|
      format.html{
        redirect_to articles_path
      }
      format.json {render :json, status: 404}
    end
  rescue => e
    flash[:alert] = "Something else went wrong"
    respond_to do |format|
      format.html{
        redirect_to articles_path
      }
      format.json {render :json, status: 418}
    end
  end

  end

  # GET /articles/new
  def new
    begin
    @article = Article.new
    rescue => e
    flash[:alert] = "Something went wrong"
    respond_to do |format|
      format.html{
        redirect_to articles_path
      }
      format.json {render :json, status: 418}
    end
  end
  end

  # GET /articles/1/edit
  def edit
    begin
  rescue => e
    flash[:alert] = "Something else went wrong"
    respond_to do |format|
      format.html{
        redirect_to articles_path
      }
      format.json {render :json, status: 418}
    end
  end
  end

  # POST /articles
  # POST /articles.json
  def create
    begin
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  rescue => e
    flash[:alert] = "Something went wrong"
      respond_to do |format|
        format.html{
          redirect_to articles_path
        }
        format.json {render :json, status: 418}
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    begin
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  rescue => e
    flash[:alert] = "Something went wrong"
      respond_to do |format|
        format.html{
          redirect_to articles_path
        }
        format.json {render :json, status: 418}
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    begin
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  rescue => e
    flash[:alert] = "Something went wrong"
      respond_to do |format|
        format.html{
          redirect_to articles_path
        }
        format.json {render :json, status: 418}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

  def set_article
    begin
      @article = Article.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        flash[:alert] = "The article you're looking for cannot be found"
        respond_to do |format|
        format.html{
          redirect_to articles_path
        }
        format.json {render :json, status: 404}
    end
    rescue => e
      flash[:alert] = "Something else went wrong"
      respond_to do |format|
        format.html{
          redirect_to articles_path
        }
        format.json {render :json, status: 418}
      end
    end
  end


    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:user_id, :title, :content, :category)
      # Students, make sure to add the user_id parameter as a symbol here ^^^^^^
    end
end
