class UsersController < ApplicationController
	# Обновлять профиль может только зарегистрированный юзер
	before_action :logged_in_user, only: [:edit, :update] 
	before_action :correct_user,   only: [:edit, :update]
	
	def index
		@users = User.all
	end

	# Показ странички юзера
	def show
	    @user = User.find(params[:id])
	    # debugger
	end

	# Страничка регистрации
	def new
	  	@user = User.new
	end

	# Действие создающее нового пользователя
	def create
	    @user = User.new(user_params)
	    if @user.save
	      @user.send_activation_email  # Действие отправки письма из модели
	      flash[:info] = "Please check your email to activate your account."
	      redirect_to root_url
	    else
	      render 'new'
	    end
	end

	# Страничка редактирования пользователя
	def edit
    	@user = User.find(params[:id]) # Переменная для создания формы
  	end

  	# Действие, которое обновлят информацию о пользователе
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

  	# Приватный метод определяющий текущего пользователя
  	def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

end
