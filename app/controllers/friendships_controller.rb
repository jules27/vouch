class FriendshipsController < ApplicationController
  def index
    @friends = current_user.friends
    @inverse_friends = current_user.inverse_friends
  end

  # TODO: not currently used
  def create
    @friendship = current_user.friendships.build(friend_id: params[:friend_id])
    if @friendship.save
      flash[:notice] = "Added friend."
      redirect_to root_url
    else
      flash[:alert] = "Unable to add friend."
      redirect_to root_url
    end
  end

  def destroy
    @friendship = current_user.friendships.find_by_friend_id(params[:id])

    # Go through all vouch lists and find this friend in shared friends,
    # and remove each entry.
    SharedFriend.find_all_by_user_id(params[:id]).each do |shared_friend|
      shared_friend.destroy
    end

    @friendship.destroy

    flash[:notice] = "Removed friendship."
    redirect_to friendships_path
  end

  # Given a list of emails, for each user with the same email, make current
  # user friends with the other user.
  def add
    params[:friends].each do |email|
      friend = User.find_by_email(email)
      next unless friend.present?

      # Check the inverse friendship and add if necessary
      friendship = Friendship.find_by_user_id_and_friend_id(friend.id, current_user.id)
      unless friendship.present?
        inverse_friendship = friend.friendships.build(friend_id: current_user.id)
        if inverse_friendship.save
          puts "Added friendship for #{friend.name} (#{friend.id}) and #{current_user.name} (#{current_user.id})"
        end
      end
    end

    render json: { success: true }
  end
end
