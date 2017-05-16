class ErrorLogsController < ApplicationController
  before_action :find_event

  def create
    @log = ErrorLog.create(log_params)
    respond_to do |f|
      f.json {render nothing: true}
    end
  end

  private
  def log_params
    params.require(:log).permit(:message, :upload_log_id)
  end
end