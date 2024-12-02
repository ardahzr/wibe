require "test_helper"

class FriendshipControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get friendship_create_url
    assert_response :success
  end

  test "should get update" do
    get friendship_update_url
    assert_response :success
  end

  test "should get destroy" do
    get friendship_destroy_url
    assert_response :success
  end
end
