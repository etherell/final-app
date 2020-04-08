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
	    @user = User.new(user_params)   	# Передача хэша user_params, через метод
	    if @user.save
	    	log_in @user 					#log_in - метод в хэлпере принимающий юзера и 
	       	flash[:success] = "Welcome!" 	# Вывод приветствия
      		redirect_to @user
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

  	# Проверка на то залогинен ли юзер
  	def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

  	# Приватный метод определяющий текущего пользователя
  	def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end


end
