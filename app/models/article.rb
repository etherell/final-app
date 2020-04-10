class Article < ApplicationRecord
	has_many :comments, dependent: :destroy 				# Связывание статьи с комментариями
	belongs_to :user										# Связывание статьи с юзером
	validates :title, presence: true, length: { in: 5..70 } # Валидация минимальной длины для заголовка статьи
	validates :text, presence: true, length: { in: 10..250 }# Масимальная длинна сообщения до 255 символов
	self.per_page = 10
end
