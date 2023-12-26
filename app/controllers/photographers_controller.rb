require 'json'
require 'rest-client'

class PhotographersController < ApplicationController
  def index
    @photographers = Photographer.all
  end

  def new
    @photographer = Photographer.new
  end
  
  def create
    username = photographer_params[:username]
    response = get_id_from_api
    nsid = response['user']['nsid']
    flickr_id = response['user']['id']
    @photographer = Photographer.new(flickr_id: flickr_id, nsid: nsid, username: username)
    @photographer.name = get_name_from_api :nsid
    if @photographer.save
      flash[:success] = "Photographer successfully added!"
      redirect_to photographer_photographs_path(@photographer.flickr_id)
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
    puts "API_RESPONSE:- #{get_name_from_api}"
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
