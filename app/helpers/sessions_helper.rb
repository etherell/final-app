module SessionsHelper

	# Действие определяющее текущего пользователя по ID в сессии или в куках
	# Возвращает пользователя, соответствующего remember-токену в куки.
	def current_user
	  if session[:user_id]
	    @current_user ||= User.find_by(id: session[:user_id])
	  elsif cookies.signed[:user_id]
	    user = User.find_by(id: cookies.signed[:user_id])       # Проверяем есть ли в куках соответствующий id
	    if user && user.authenticated?(cookies[:remember_token])# Проверяем есть ли в куках соответствующий токен, т.е. авторизирован ли пользователь
	      log_in user
	      @current_user = user
	    end
	  end
	end
	
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

	# Действие проверяющее залогинен ли пользователь
	def logged_in?
	   !current_user.nil?
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
