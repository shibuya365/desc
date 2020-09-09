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

  # test "should get show" do
  #   get post_path(@user)
  #   assert_response :success
  #   assert_select "title", "#{@user.name} | #{@base_title}"
  # end

  test "should get new" do
    get new_post_path
    assert_response :success
  end

  # test "should get edit" do
  #   get edit_user_path(@user)
  #   assert_response :success
  # end


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
