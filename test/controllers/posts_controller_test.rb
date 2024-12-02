require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
    @post = posts(:one)
  end

  test "should get index" do
    get posts_index_url
    assert_response :success
  end

  test "should get show" do
    get posts_show_url
    assert_response :success
  end

  test "should get new" do
    get posts_new_url
    assert_response :success
  end

  test "should get create" do
    get posts_create_url
    assert_response :success
  end

  test "should create post when authenticated" do
    assert_difference("Post.count") do
      post posts_url, params: { post: { content: "Test content" } }
    end
    assert_redirected_to posts_path
  end

  test "should not create post when not authenticated" do
    sign_out @user
    assert_no_difference("Post.count") do
      post posts_url, params: { post: { content: "Test content" } }
    end
    assert_redirected_to new_user_session_path
  end
end