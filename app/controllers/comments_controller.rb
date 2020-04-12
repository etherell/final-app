class CommentsController < ApplicationController
	before_action :current_article

	def create
		@comment = @article.comments.build(comment_params)
    @comment.user = current_user
    @comment.save

    respond_to do |format|
    	if @comment.save
				format.js
				format.html { redirect_to article_path(@article) }	
			end
		end
	end

	def destroy
		@comment = @article.comments.find(params[:id])
		if @comment.user == current_user
			@comment.destroy
				respond_to do |format|
					format.js
					format.html { redirect_to article_path(@article) }	
				end
		else
			flash[:danger] = "You can't do this!"
		end
	end

	private
	def comment_params
		params.require(:comment).permit(:commenter, :body)
	end

	def current_article
    	@article = Article.find(params[:article_id])
  	end
end
