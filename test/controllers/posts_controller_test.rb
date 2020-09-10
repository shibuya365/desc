require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @post = posts(:orange)
    @base_title = "DESC"
  end

  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "Edited by everyone | #{@base_title}"
  end

  test "should get index" do
    get posts_path
    assert_response :success
    assert_select "title", "Everyone touched | #{@base_title}"
  end

  test "should get show" do
    get post_path(@post)
    assert_response :success
    assert_select "title", "Post | #{@base_title}"
  end

  test "should get new" do
    get new_post_path
    assert_response :success
    assert_select "title", "New post | #{@base_title}"
  end

  test "should get post" do
    log_in_as(@user)
    post posts_path, params:  { post: { content: "Hello!" } }
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  # test "should get edit" do
  #   get edit_post_path(@post)
  #   assert_response :success
  # end

  test "should not get destroy without login" do
    assert_no_difference 'Post.count' do
      delete post_path(@user.posts.first)
    end

  end

  test "should get destroy with login" do
    assert_difference 'Post.count', -1 do      
      log_in_as(@user)
      delete post_path(@user.posts.first)
      assert_not flash.empty?
      assert_redirected_to root_path
    end
  end


  # test "should redirect create when not logged in" do
  #   assert_no_difference 'Post.count' do
  #     post posts_path, params: { post: { content: "Lorem ipsum" } }
  #   end
  #   assert_redirected_to new_session_path
  # end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end
    assert_redirected_to new_session_path
  end

  test "should redirect destroy for wrong post" do
    log_in_as(users(:michael))
    post = posts(:ants)
    assert_no_difference 'Post.count' do
      delete post_path(post)
    end
    assert_redirected_to root_url
  end


end
