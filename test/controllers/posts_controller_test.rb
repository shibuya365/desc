require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @post = posts(:orange)
    @base_title = "DESC"
  end

  # home
  test "should get home" do
    get root_path
    assert_response :success
    # もっとも新しいupdated_atが含まれているか
    assert_match posts(:most_recent_updated).content, response.body
    assert_select "title", "Edited by everyone | #{@base_title}"
  end

  # 1 index
  test "should get index" do
    get posts_path
    assert_response :success
    # もっとも新しいcreated_atが含まれているか
    assert_match posts(:most_recent_created).content, response.body
    assert_select "title", "Everyone touched | #{@base_title}"
  end

  # 2 show
  test "should get show" do
    get post_path(@post)
    assert_response :success
    assert_select "title", "Post | #{@base_title}"
  end

  # 3 new
  test "should get new" do
    get new_post_path
    assert_response :success
    assert_select "title", "New post | #{@base_title}"
  end

  # 4 create
  test "should get post" do
    log_in_as(@user)
    post posts_path, params:  { post: { content: "Hello!" } }
    assert_not flash.empty?
    assert_redirected_to root_path
  end


  # 5 edit
  test "should not get edit with login" do
    log_in_as(@user)
    get edit_post_path(@post)
    assert_template 'posts/edit'
    assert_response :success
    assert_select "title", "Edit post | #{@base_title}"
  end

  test "should not get edit without login" do
    get edit_post_path(@post)
    assert_redirected_to new_session_path
  end

  # 6 update
  test "should not get update without login" do
    patch post_path(@post), params: { post: { content: "Hello!" } }
    assert_not_equal( @post.content, "Hello!")
    assert_not flash.empty?
    assert_redirected_to new_session_path
  end

  test "should not get update with wrong user" do
    log_in_as(@other_user)
    @post = @user.posts.first
    content = "Hello!"
    patch post_path(@post), params: { post: { content: content} }
    @post.reload
    assert_not_equal( @post.content, content)
    assert_redirected_to root_url
  end

  test "should get update with right user" do
    log_in_as(@user)
    @post = @user.posts.first
    content = "Hello!"
    patch post_path(@post), params: { post: { content: content} }
    @post.reload
    assert_equal( @post.content, content)
    assert_not flash.empty?
  end

  # 7 destroy
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

  # append
  test "add append post with loggin" do
    log_in_as(@user)
    content = @post.content
    patch append_post_path(@post), params: { post: { addendum: "addendum"} }
    @post.reload
    assert_equal( @post.content, content + "\n" + "---" + "\n" + Date.today.to_s + "\n" + @user.name + "\n" + "addendum")
  end

  test "add append post without loggin" do
    content = @post.content
    patch append_post_path(@post), params: { post: { addendum: "addendum"} }
    @post.reload
    assert_equal( @post.content, content + "\n" + "---" + "\n" + Date.today.to_s + "\n" + "Guest" + "\n" + "addendum")
  end

end
