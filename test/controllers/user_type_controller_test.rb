require "test_helper"

class UserTypeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_type_index_url
    assert_response :success
  end
end
