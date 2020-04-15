class ArticlesController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update] 
	before_action :current_article, only: [:show, :edit, :update, :destroy]
	#require 'pry'

	def index
		@articles = Article.includes(:user).where(["title LIKE ?","%#{params[:search]}%"])
		.paginate(page: params[:page]).order('created_at DESC')
	end

	def show
		@comments = @article.comments.includes(:user).paginate(page: params[:page], per_page: 3).order('created_at DESC')
		# binding.pry
	end

	def new
		@article = Article.new
	end

	def edit
	end

	def create
	 	@article = Article.new(article_params)
	 	@article.user = current_user
	 	
	 	if @article.save
	 		redirect_to @article
	 	else
	 		render 'new'
	 	end
	end 

	def update
		if @article.update(article_params)
			redirect_to @article
		else
			render 'edit'
		end
	end

	def destroy
		if current_user == @article.user
			@article.destroy
			redirect_to articles_path
		else
			flash[:danger] = "You can't do this!"
		end
	end

	private
  	def current_article
    	@article = Article.find(params[:id])
  	end
	
	def article_params
    	params.require(:article).permit(:title, :text)
  	end

end
