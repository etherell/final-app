module SessionsHelper

	# Действие назначающее сессии айди пользователя
	def log_in(user)
	  session[:user_id] = user.id
	end

  	# Запоминает пользователя в постоянную сессию.
  	def remember(user)
    	user.remember                              # генерирует remember-токен и сохраняет в базу данных его дайджест
    	cookies.permanent.signed[:user_id] = user.id # запись и шифрование юзер ID
    	cookies.permanent[:remember_token] = user.remember_token
  	end

  	# Возвращает true если текущий юзер это current user
  	def current_user?(user)
    	user == current_user
  	end

	# Возвращает текущего пользователя, осуществившего вход (если он есть)
	def current_user
	  if (user_id = session[:user_id])
	    @current_user ||= User.find_by(id: user_id)
	  elsif (user_id = cookies.signed[:user_id])
	    user = User.find_by(id: user_id)
	    if user && user.authenticated?(:remember,cookies[:remember_token])
	      log_in user
	      @current_user = user
	    end
	  end
	end


	# Действие проверяющее залогинен ли пользователь
	def logged_in?
	  current_user != nil
	end

	# Забывает постоянную сессии.
	def forget(user)
	  user.forget					# Назначение nil значению remember_digest из базы
	  cookies.delete(:user_id)
	  cookies.delete(:remember_token)
	end

	# Действие удаляющее текущую сессию и юзера
	def log_out
	  forget(current_user)
	  session.delete(:user_id)
	  @current_user = nil
	end
end
