require 'test_helper'

class Analytics::MoneyControllerTest < ActionController::TestCase
  test "should get overview" do
    get :overview
    assert_response :success
  end

end
