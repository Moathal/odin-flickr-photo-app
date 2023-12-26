require 'rest-client'
require 'json'
require 'redis'

class PhotoGrabJob
  include Sidekiq::Worker

  def perform(flickr_id)
    base_url = "https://api.flickr.com/services/rest/"
    params = {
      method: 'flickr.people.getPublicPhotos',
      api_key: ENV['flickr_api_key'],
      user_id: flickr_id,
      format: 'json',
      nojsoncallback: 1
    }
    response = RestClient.get("#{base_url}?#{params.to_query}")
    REDIS.setex("photos#{flickr_id}", 720000, response.body)
    response = JSON.parse(response.body)
    photos = response['photos']['photo']
    Turbo::StreamsChannel.broadcast_replace_to("#{flickr_id}:photos", partial: 'photographs/photos', locals: { photos: photos}, target: 'loading_frame')
  end
end