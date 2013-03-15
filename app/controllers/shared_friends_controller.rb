class SharedFriendsController < ApplicationController
  def destroy
    shared_friend = SharedFriend.find(params[:id])
    shared_friend.destroy
    render json: { success: true }
  end
end
