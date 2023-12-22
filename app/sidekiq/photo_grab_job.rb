require 'rest-client'
require 'json'

class PhotoGrabJob
  include Sidekiq::Job

  def perform(flickr_id)
    base_url = "https://api.flickr.com/services/rest/"
    params = {
      method: 'flickr.people.getPublicPhotos',
      api_key: ENV['flickr_api_key'],
      user_id: flickr_id,
      format: 'json',
      nojsoncallback: 1
    }
    @response = RestClient.get("#{base_url}?#{params.to_query}")
    Turbo::StreamsChannel.broadcast_replace_to("photographer:#{fliker_id}:photos", partial: 'photos', locals: { photos: @response })
  end
end
