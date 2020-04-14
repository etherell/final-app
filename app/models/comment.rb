class Comment < ApplicationRecord
	belongs_to :article 									
  	belongs_to :user 										
	validates :body, presence: true, length: { in: 5..200 } 
end
