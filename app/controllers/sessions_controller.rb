class SessionsController < ApplicationController

  # Login page
  def new
  end

  # Creates session for user
 def create
  user = User.find_by(email: params[:session][:email].downcase) # finds user by email in DB
  if user && user.authenticate(params[:session][:password])     # compares user password with session password
    if user.activated?                                          # checks if account activated
       log_in user
       params[:session][:remember_me] == '1' ? remember(user) : forget(user)
       redirect_back_or user
    else
       message  = "Account not activated. "
       message += "Check your email for the activation link."
       flash[:warning] = message
       redirect_to root_url
     end
    else   
    flash[:danger] = 'Invalid email/password combination'
    render 'new'
  end
 end

  # Logs user out
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
