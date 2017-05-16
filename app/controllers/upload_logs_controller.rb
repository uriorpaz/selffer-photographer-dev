class UploadLogsController < ApplicationController
  before_action :find_event

  def create
    @log = @event.upload_logs.create(log_params)
    respond_to do |f|
      f.json {render json: {id: @log.id}}
    end
  end

  def update
    @log = @event.upload_logs.find(params[:id])
    @log.update(log_params)
    respond_to do |f|
      f.json {render nothing: true}
    end
  end

  private
  def log_params
    params[:log][:start_at] = Time.at(params[:log][:start_at].to_i) if params[:log][:start_at].present?
    params[:log][:end_at] = Time.at(params[:log][:end_at].to_i) if params[:log][:end_at].present?
    params.require(:log).permit(:start_at, :end_at, :photos_start_count,
                                :photos_end_count, :duplicates_count, :fail_count, :not_photo_count)
  end
end
