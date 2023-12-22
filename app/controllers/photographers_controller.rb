class PhotographersController < ApplicationController
  def index
    @photographers = Photographer.all
  end

  def new
    @photographer = Photographer.new
  end

  def def create
    @photographer = Photographer.new(params[:photographer])
    if @photographer.save
      flash[:success] = "Object successfully created"
      redirect_to @photographer
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end
  
end
