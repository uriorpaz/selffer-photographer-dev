class PhotographersController < ApplicationController
  before_action :find_photographer

  def profile
    if request.path != url_for(only_path: true)
      redirect_to url_for, status: :moved_permanently
    end
    if current_photographer.try(:is_owner)
      redirect_to photographer_profile_path(current_photographer)
    end
  end

  def upd
    if @photographer.update(photographer_params)
      flash[:notice] = "Your profile successfully updated"
    else
      flash[:alert] = "Service not available. try again later"
    end
    # PhotographerSyncWorker.perform_async(@photographer.id) unless Rails.env=="development"
    redirect_to photographer_profile_path(@photographer)
  end

  private
  def photographer_params
    params.require(:photographer).permit( :name, :studio_name, :street, :zipcode,
                                          :city, :country, :mobile_number, :office_number,
                                          :website, :facebook, :twitter, :instagram, :logo,
                                          :crop_x, :crop_y, :crop_w, :crop_h, :crop_rotate )
  end
end
