class VouchListsController < ApplicationController
  def new
    @restaurants = Business.find_all_by_city("San Francisco")
    @vouch_list  = VouchList.new
  end

  def create
    @vouch_list  = VouchList.new(params[:vouch_list])
    if @vouch_list.save
      redirect_to @vouch_list
    else
      render 'new', alert: "The list was unable to be created."
    end
  end
end
