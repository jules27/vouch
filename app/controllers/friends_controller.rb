class FriendsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @friends = current_user.friends
    @city    = current_user.city || City.first
  end
end
