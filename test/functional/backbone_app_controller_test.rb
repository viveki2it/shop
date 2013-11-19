require 'test_helper'

class BackboneAppControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

end
