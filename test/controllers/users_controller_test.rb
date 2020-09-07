require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @base_title = "DESC"
  end

  test "should get new" do
    get new_user_path
    assert_response :success
    assert_select "title", "Sign up | #{@base_title}"
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to new_session_path
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name } }
    assert_not flash.empty?
    assert_redirected_to new_session_path
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name } }
    assert flash.empty?
    assert_redirected_to root_url
  end

end
