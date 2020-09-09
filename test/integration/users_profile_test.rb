require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', "#{@user.name} | DESC"
    assert_select 'h1', text: @user.name
    assert_match @user.posts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.posts.paginate(page: 1).each do |post|
      assert_match post.content, response.body
    end
  end
end
