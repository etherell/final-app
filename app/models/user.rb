class User < ApplicationRecord
	# Валидации
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
end
