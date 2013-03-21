class WishListsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @wish_list = current_user.wish_list_primary
    @type      = BusinessType.find(1)
  end
end
