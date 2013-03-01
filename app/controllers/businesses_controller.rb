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
end
