class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # どのコントローラでも使えるように
  include SessionsHelper
end
