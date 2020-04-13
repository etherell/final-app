class User < ApplicationRecord
	
	attr_accessor :remember_token, :activation_token
	# Валидации
	before_save :downcase_email
	before_create :create_activation_digest
	before_save { self.email = email.downcase } 	 			# Приведение email к одному виду
	validates :name,  presence: true, length: { maximum: 50 }  	# Имя до 50 символов
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i    # Регулярное вырожение для email
	validates :email, presence: true, length: { maximum: 255 },	# Все требования к почте
	                  format: { with: VALID_EMAIL_REGEX },
	                  uniqueness: { case_sensitive: false }
	validates :password, presence: true, length: { minimum: 6 },# Валидация пароля
												 allow_nil: true

	# Связывание + пароль
	has_secure_password											# Добавление пароля	
	has_one_attached :avatar									# Добавления аватара
	has_many :comments											# Связь с комментариями
	has_many :articles											# Связь со статьями

	# Возвращает дайджест данной строки
  	def User.digest(string)
    	cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    	BCrypt::Password.create(string, cost: cost)
  	end

  	# Возвращает случайный токен
 	def User.new_token
    	SecureRandom.urlsafe_base64
  	end

  	# Запоминает пользователя в базе данных для использования в постоянной сессии.
 	def remember
    	self.remember_token = User.new_token 								# Записываем в куки токен
    	update_attribute(:remember_digest, User.digest(remember_token))		# Обновляем remember_digest зашифрованным remember_token
  	end

  	# Забывает пользователя
  	def forget
    	update_attribute(:remember_digest, nil)
  	end
	
	# Возвращает true, если предоставленный токен совпадает с дайджестом.
	def authenticated?(remember_token)
		return false if remember_digest.nil?
    	BCrypt::Password.new(remember_digest).is_password?(remember_token)
  	end

	# Ковертация email в нижний регистр
	private
	def downcase_email
		self.email = email.downcase
	end

	# Создает и присваивает активационнй токен и дайджест
	def create_activation_digest
		self.activation_token = User.new_token
		self.activation_digest = User.digest(activation_token)
	end
end
