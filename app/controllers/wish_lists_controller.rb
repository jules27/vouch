class WishListsController < ApplicationController
  def index
    @wish_lists = current_user.wish_lists
  end
end
