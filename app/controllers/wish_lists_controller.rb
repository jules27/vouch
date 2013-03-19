class WishListsController < ApplicationController
  def index
    @wish_list = current_user.wish_list_primary
  end
end
