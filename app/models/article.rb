class Article < ApplicationRecord
	has_many :comments, dependent: :destroy 				
	belongs_to :user										
	validates :title, presence: true, length: { in: 5..70 } 
	validates :text, presence: true, length: { in: 10..250 }
	self.per_page = 10
end
