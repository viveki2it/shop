require 'test_helper'

class ScrapeCheckerControllerTest < ActionController::TestCase
  test "should get check" do
    get :check
    assert_response :success
  end

end
