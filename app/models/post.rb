class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes


  attr_accessor :addendum
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 10000 }
end
