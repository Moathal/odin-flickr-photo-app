require 'json'
require 'rest-client'

class PhotographersController < ApplicationController
  def index
    @photographers = Photographer.all
  end
  
  def create
    username = photographer_params[:username]
    response = get_id_from_api
    nsid = response['user']['nsid']
    flickr_id = response['user']['id']
    @photographer = Photographer.new(flickr_id: flickr_id, nsid: nsid, username: username)
    name = get_name_from_api(nsid)
    @photographer.name = name
    if @photographer.save
      flash[:success] = "Photographer successfully added!"
      redirect_to photographer_photographs_path(@photographer.id)
    else
      flash[:error] = "Something went wrong"
      redirect_to photographers_path
    end
  end

  def get_id_from_api
     response = RestClient.get "https://www.flickr.com/services/rest/", {
      params: {
      method: "flickr.people.findByUsername",
      api_key: ENV['flickr_api_key'],
      username: photographer_params[:username],
      format: "json",
      nojsoncallback: 1
    }
  }
  JSON.parse(response.body)
  end

  def get_name_from_api(nsid)
     response = RestClient.get "https://www.flickr.com/services/rest/", {
      params: {
      method: "flickr.people.getInfo",
      api_key: ENV['flickr_api_key'],
      user_id: nsid,
      format: "json",
      nojsoncallback: 1
    }
  }
  response = JSON.parse(response)
  response['person']['realname']['_content']
  end
  
  private

  def photographer_params
    params.require(:photographer).permit(:username)
  end
end
