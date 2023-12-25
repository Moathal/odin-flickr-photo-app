class PhotographsController < ApplicationController
  def index
    @photographer = Photographer.find(params[:photographer_id])
    PhotoGrabJob.perform_async(@photographer.flickr_id)
  end
end
