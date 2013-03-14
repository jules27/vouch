class FriendsController < ApplicationController
  def index
    @friends = current_user.friends
    @city    = current_user.city
  end
end
