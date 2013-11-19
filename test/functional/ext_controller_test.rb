require 'test_helper'

class ExtControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

end
