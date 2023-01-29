require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "username must be unique" do
    existing_user = users(:one)
    user = User.new(username: existing_user.username)
    assert_not user.valid?, "User should be invalid with duplicate username"
    assert_includes user.errors[:username], "has already been taken",  "User should have error on username"
  end
end
