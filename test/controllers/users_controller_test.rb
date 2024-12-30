require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @user = users(:one)
  end

  test "should get show when signed in" do
    sign_in @user
    get user_path(@user)
    assert_response :success
  end

  test "should get edit registration when signed in" do
    sign_in @user
    get edit_user_registration_path
    assert_response :success
  end
end
