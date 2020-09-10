require 'test_helper'

class PostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "post interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # 無効な送信
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    content = "This post really ties the room together"
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select 'a', text: 'delete'
    first_post = @user.posts.paginate(page: 1).first
    assert_difference 'Post.count', -1 do
      delete post_path(first_post)
    end
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

  test "post sidebar count" do
    log_in_as(@user)
    get user_path(@user)
    assert_match "Posts (#{@user.posts.count})", response.body
    # まだマイクロポストを投稿していないユーザー
    other_user = users(:malory)
    log_in_as(other_user)
    get user_path(other_user)
    # assert_match "Post (0)", response.body
    other_user.posts.create!(content: "A post")
    get user_path(other_user)
    assert_match "Posts (1)", response.body
  end


end
