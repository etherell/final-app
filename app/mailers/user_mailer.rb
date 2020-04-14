class UserMailer < ApplicationMailer

	# Creates account_activation mail
	def account_activation(user)
	  @user = user
	  mail to: user.email, subject: "Account activation"
	end

	# Creates password_reset mail
	def password_reset(user)
	  @user = user
	  mail to: user.email, subject: "Password reset"
	end
end
