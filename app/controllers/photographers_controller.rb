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
    name = get_name_from_api 
    @photographer = Photographer.new(photographer_params)
    @photographer.name = name
    if @photographer.save
      flash[:success] = "Photographer successfully added!"
      redirect_to photographer_photographs_path(@photographer.flickr_id)
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  def get_name_from_api
     response = RestClient.get "https://www.flickr.com/services/rest/", {
      params: {
      method: "flickr.people.getInfo",
      api_key: ENV['flickr_api_key'],
      user_id: photographer_params[:filckr_id],
      format: "json",
      nojsoncallback: 1
    }
  }
  JSON.parse(response.body)
  end
  
  private

  def photographer_params
    params.require(:photographer).permit(:flickr_id)
  end
end
