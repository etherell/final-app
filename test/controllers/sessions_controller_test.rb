require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  test "should get new" do
    flash.now[:danger] = 'Invalid email/password combination'
    render 'new'
  end

end
