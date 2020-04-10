class ArticlesController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update] 
	before_action :current_article, only: [:show, :edit, :update, :destroy]
	require 'will_paginate/array'


	# Сочетание действия Index и Поиска в одном
	def index
		@articles = Article.where(["title LIKE ?","%#{params[:search]}%"])
		.paginate(page: params[:page]).order('created_at DESC')
		# @articles = []
		# Article.where(["title LIKE ?","%#{params[:search]}%"]).each do |article|
		# 	@articles.push(article)
		# end

		# @articles = @articles.paginate(page: params[:page], per_page: 2)
	end

	# Действие для вывода одной статьи
	def show
	end

	# Действие которое выводит форму для создания статей
	def new
		@article = Article.new
	end

	# Действие которое выводит форму для редактироания статьи
	def edit
	end

	# Действие которое создаёт новую статью с заполненными параметрами, которые принимаются из приватного метода
	# HTTP - POST
	def create
	 	@article = Article.new(article_params)
	 	@article.user = current_user
	 	
	 	if @article.save
	 		redirect_to @article
	 	else
	 		render 'new'
	 	end
	end 

	# Действие обновляющее статью (HTTP - PATCH/PUT)
	def update
		if @article.update(article_params)
			redirect_to @article
		else
			render 'edit'
		end
	end

	# Действие удаляющее статью (HTTP - DELETE)
	def destroy
		if current_user == @article.user
			@article.destroy
			redirect_to articles_path
		else
			flash[:danger] = "You can't do this!"
		end
	end

	# Запись текущей статьи в переменную
  	def current_article
    	@article = Article.find(params[:id])
  	end

	# Приватный метод который передаёт параметры
	def article_params
    	params.require(:article).permit(:title, :text)
  	end

end
