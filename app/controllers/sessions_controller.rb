class SessionsController < ApplicationController
  # Действие создающее страницу login
  def new
  end

  # Действие создающее сессию для пользователя
 def create
   user = User.find_by(email: params[:session][:email].downcase)
   if user && user.authenticate(params[:session][:password])
     log_in user    		# Действие из sessions_helper
     params[:session][:remember_me] == '1' ? remember(user) : forget(user) # Если флажок установлен записываем в куки
     redirect_to user
   else
     flash.now[:danger] = 'Invalid email/password combination'
     render 'new'
   end
 end

  # Действие выполняющее Log-out
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
