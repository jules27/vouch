class VouchListsController < ApplicationController
  def new
    @restaurants = Business.find_all_by_city("San Francisco")
    @vouch_list  = VouchList.new
  end
end
