require "test_helper"

class FriendshipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @friendship = friendships(:one)
  end

  test "should create friendship" do
    post friendships_url, params: { friendship: { friend_id: users(:two).id } }
    assert_response :redirect
  end

  test "should update friendship" do
    patch friendship_url(@friendship), params: { friendship: { confirmed: true } }
    assert_response :redirect
  end

  test "should destroy friendship" do
    delete friendship_url(@friendship)
    assert_response :redirect
  end
end