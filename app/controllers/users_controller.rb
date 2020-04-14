class UsersController < ApplicationController
	# Only logged in user can make changes in profile and only in his profile
	before_action :logged_in_user, only: [:edit, :update] # users helper action
	before_action :correct_user,   only: [:edit, :update]
	
	def index
		@users = User.all
	end

	# User page
	def show
	    @user = User.find(params[:id])
	end

	# Registration page
	def new
	  	@user = User.new
	end

	# Creates new user (sign up)
	def create
	    @user = User.new(user_params)
	    if @user.save
	      @user.send_activation_email  # send mail action from model
	      flash[:info] = "Please check your email to activate your account."
	      redirect_to root_url
	    else
	      render 'new'
	    end
	end

	# Profile edit page
	def edit
    	@user = User.find(params[:id]) 
  	end

  	# Updates information about user
  	def update
    	@user = User.find(params[:id])
    	if @user.update_attributes(user_params)
      		flash[:success] = "Profile updated"
     		redirect_to @user
    	else
      		render 'edit'
    	end
  	end

	private
	# Gets params from form
	def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :avatar)
  	end

  	# Prevents edit actions with pages of other users
  	def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

end
