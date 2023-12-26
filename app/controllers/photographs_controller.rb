require 'redis'
require 'json'

class PhotographsController < ApplicationController
  def index
    @photographer = Photographer.find(params[:photographer_id])
    response = REDIS.get("photos#{@photographer.flickr_id}")
    if response.nil?
      @photos = nil
      PhotoGrabJob.perform_async(@photographer.flickr_id)
    else
      response = JSON.parse(response)
      @photos = response['photos']['photo']
    end
  end
end
