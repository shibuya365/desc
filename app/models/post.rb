class Post < ApplicationRecord
  attr_accessor :addendum
  
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 10000 }
end
