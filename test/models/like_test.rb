require 'test_helper'

class LikeTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @post = posts(:most_recent_updated)
    @like = Like.new(user_id: @user.id, post_id: @post.id)
    # @like = @user.likes.build(post_id: @post.id)
  end

  test "should be valid" do
    assert @like.valid?
  end

  test "user id should be present" do
    @like.user_id = nil
    assert_not @like.valid?
  end

  test "post id should be present" do
    @like.post_id = nil
    assert_not @like.valid?
  end

  test "should like post" do
    # postにtouchしてないことを確認
    assert_not @user.like_posts.include?(@post)
    # touchする
    @user.like_posts << @post
    # touchしてるか確認
    assert @user.like_posts.include?(@post)
    # touchを解除
    @user.like_posts.find(@post.id).destroy
    # postにtouchしてないことを確認
    assert_not @user.like_posts.include?(@post)
  end

end
