class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    # <%= #link_to 'Reject%', destroy_friendship_url(@user.fri) %>
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
    if @user.id == current_user.id
      @friends_ids = @user.confirmed_friends.map { |user| user.id }
      @posts += Post.where('posts.user_id in (?)', @friends_ids).ordered_by_most_recent
    end
  end

  def confirm_friendship
    friendship = current_user.confirm_friend(params[:friend_id])
    if friendship.nil?
      redirect_to user_path(current_user), alert: 'Could not find friend request'
    elsif friendship.errors
      redirect_to user_path(current_user), alert: friendship.errors.full_messages.join('. ').to_s
    else
      redirect_to user_path(current_user), notice: 'Friend successfully confirmed'
    end
  end
end
