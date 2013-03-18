class BusinessesController < ApplicationController
  def details
    @business = Business.find_by_name_and_city(params[:name], params[:city])

    respond_to do |format|
      format.json do
        if @business.present?
          render json: { success: true,
                         business: @business }
        else
          render json: {
                         status: 422,
                         errors: "Unable to find business named \"#{params[:name]}\" in #{params[:city]}."
                       }
        end
      end
    end
  end

  def new_by_type
    @business = Business.new
    @business_type = BusinessType.find_by_name(params[:type])
    render action: "new_by_type",
           locals: {
                     business_type: @business_type
                   }
  end

  def create
    @business = Business.new(params[:business])
    @business_type = BusinessType.find(params[:business][:business_type_id])

    if @business.save
      flash[:notice] = "New #{@business_type.name} \"#{@business.name}\" was successfully created."
      # flash.keep(:notice)
      redirect_to vouch_lists_path
    else
      flash[:error]  = @business.errors.full_messages
      redirect_to new_business_by_type_path(@business_type.name)
    end
  end
end
