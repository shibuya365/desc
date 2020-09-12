require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @post = posts(:ants)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', "#{@user.name} | DESC"
    assert_select 'h1', text: @user.name
    assert_match @user.like_posts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.like_posts.paginate(page: 1).each do |post|
      assert_match post.content, response.body
    end
  end

  test "check add touch when show" do
    assert_difference 'Like.count', 1 do
      log_in_as(@user)
      get post_path(@post)
    end
  end

end
