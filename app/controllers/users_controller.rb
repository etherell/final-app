class UsersController < ApplicationController
	# Показ странички юзера
	def show
	    @user = User.find(params[:id])
	    # debugger
	end

	# Страничка регистрации
	def new
	  	@user = User.new
	end

	def create
	    @user = User.new(user_params)  
	    if @user.save
	       flash[:success] = "Please sign in"
      		redirect_to login_path
	    else
	      	render 'new'
	    end
	end

	def edit
    	@user = User.find(params[:id])
  	end

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
	# Приватный метод получающий параметры
	def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :avatar)
  	end

end
