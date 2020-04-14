class User < ApplicationRecord
	
	# Attributes and before actions
	attr_accessor :remember_token, :activation_token, :reset_token
	before_save   :downcase_email
  	before_create :create_activation_digest

  	# Relations
	has_secure_password											# Password adding
	has_one_attached :avatar									# Picture adding
	has_many :comments											# Can create coments
	has_many :articles											# Can create articles

	# Validations
	before_save { self.email = email.downcase } 	 			
	validates :name,  presence: true, length: { maximum: 50 }  	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i    # Regex for email
	validates :email, presence: true, length: { maximum: 255 },	# Validations for email
	                  format: { with: VALID_EMAIL_REGEX },
	                  uniqueness: { case_sensitive: false }
	validates :password, presence: true, length: { minimum: 6 },
												 allow_nil: true



	# Creates diges from string
  	def User.digest(string)
    	cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    	BCrypt::Password.create(string, cost: cost)
  	end

  	# Returns random token
 	def User.new_token
    	SecureRandom.urlsafe_base64
  	end

  	# New token to cookies and update rememver_diges in DB
 	def remember
    	self.remember_token = User.new_token 								# 
    	update_attribute(:remember_digest, User.digest(remember_token))		# Обновляем remember_digest зашифрованным remember_token
  	end

  	# Returns true if the token is equal to the digest
	def authenticated?(attribute, token)
	  digest = send("#{attribute}_digest")
	  return false if digest.nil?
	  BCrypt::Password.new(digest).is_password?(token)
	end


  	# Forgets user (cookies)
  	def forget
  	  update_attribute(:remember_digest, nil)
  	end

	# Account activation
	def activate
	  update_attribute(:activated,    true)
	  update_attribute(:activated_at, Time.zone.now)
	end

	# Send activation mail
	def send_activation_email
	  UserMailer.account_activation(self).deliver_now
	end

	# Sends email for password reset
	def send_password_reset_email
	  UserMailer.password_reset(self).deliver_now
	end

	 # Creates attributes for password reset
	 def create_reset_digest
	   self.reset_token = User.new_token
	   update_attribute(:reset_digest,  User.digest(reset_token))
	   update_attribute(:reset_sent_at, Time.zone.now)
	 end

	# Returns true if password digest isn't valid because of time
	def password_reset_expired?
	  reset_sent_at < 2.hours.ago
	end

	private
	# Converting email in downcase
	def downcase_email
	  self.email = email.downcase
	end

	# Creates and assigns activation token and digest
	def create_activation_digest
	  self.activation_token  = User.new_token
	  self.activation_digest = User.digest(activation_token)
	end

end
