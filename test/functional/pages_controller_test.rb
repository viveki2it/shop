require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get privacy" do
    get :privacy
    assert_response :success
  end

end
