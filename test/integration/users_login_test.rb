require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do
    get new_session_path
    assert_template 'sessions/new'
    post sessions_path, params: { session: { name: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get new_user_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get new_session_path
    post sessions_path, params: { session: { name: @user.name, password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", new_session_path, count: 0 #login
    assert_select "a[href=?]", session_path(@user) #logout
    assert_select "a[href=?]", user_path(@user) 
    delete session_path(@user)
    assert_not is_logged_in?
    assert_redirected_to root_url
    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete session_path(@user)
    follow_redirect!
    assert_select "a[href=?]", new_session_path #login
    assert_select "a[href=?]", session_path(@user), count: 0 #logout
    # assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do
    # クッキーを保存してログイン
    log_in_as(@user, remember_me: '1')
    delete session_path(@user)
    # クッキーを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end

end
