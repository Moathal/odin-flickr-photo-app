class PhotographsController < ApplicationController
  def index
    @photos = []
    if @photos.empty?
      PhotoGrabJob.perform(params[:flickr_id])
      render turbo_stream: turbo_stream.append('photos', partial: 'loading')
    else
      render @photos
    end
  end
end
