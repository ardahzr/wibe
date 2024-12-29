require "test_helper"

class LikeTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @post = posts(:one)
    @like = Like.new(user: @user, post: @post)
  end

  test "should be valid" do
    assert @like.valid?
  end

  test "should require a user" do
    @like.user = nil
    assert_not @like.valid?
  end

  test "should require a post" do
    @like.post = nil
    assert_not @like.valid?
  end
end
