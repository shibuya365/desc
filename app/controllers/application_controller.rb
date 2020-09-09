class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # どのコントローラでも使えるように
  include SessionsHelper

  private
  
    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to new_session_path
      end
    end
end
