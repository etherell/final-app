class Comment < ApplicationRecord
	belongs_to :article 									# Связывание комментария с article
  	belongs_to :user 										# Связывание комментария с article
	validates :body, presence: true, length: { in: 5..200 } # Валидация минимальной длины для заголовка статьи
end
