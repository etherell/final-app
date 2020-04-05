class ApplicationController < ActionController::Base
	def hello
		rener html: "Hello world!"
	end
end
