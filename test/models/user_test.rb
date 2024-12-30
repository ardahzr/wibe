require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user without username" do
    user = users(:one).dup
    user.username = nil
    assert_not user.save, "Saved user without username"
  end

  test "should not save user with duplicate username" do
    existing_user = users(:one)
    user = users(:two).dup
    user.username = existing_user.username
    assert_not user.save, "Saved user with duplicate username"
  end
end