source 'https://rubygems.org'

gem 'rails',                   '5.1.6'

# マークダウン形式で表示するためのgem
gem 'redcarpet', '~> 2.3.0'
# シンタックスハイライトに対応させるためのgem
gem 'coderay'

# 最先端のハッシュ関数
gem 'bcrypt'

# 名前を作る
gem 'faker'

# ページネーション
gem 'will_paginate'
gem 'bootstrap-will_paginate'

# Bootstrap
gem 'bootstrap-sass'

gem 'puma'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder'

group :development, :test do
  gem 'sqlite3'

  # debug用
  gem 'byebug',  '9.0.6', platform: :mri
end

group :development do
  gem 'web-console'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  gem 'rails-controller-testing'
  gem 'minitest'

  # テストで red や green を表示
  gem 'minitest-reporters'

  gem 'guard-minitest'
end

group :production do
  gem 'pg'
end
