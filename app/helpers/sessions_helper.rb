module SessionsHelper

	# Действие определяющее текущего пользователя по ID в сессии
	def current_user
	   @current_user ||= User.find_by(id: session[:user_id])
	end

	# Действие назначающее сессии айди пользователя
	def log_in(user)
	  session[:user_id] = user.id
	end

	# Действие проверяющее залогинен ли пользователь
	def logged_in?
	   !current_user.nil?
	end

	# Действие удаляющее текущую сессию и юзера
	def log_out
	    session.delete(:user_id)
	    @current_user = nil
  	end
end
