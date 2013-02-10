class ConferencesController < ApplicationController

  def index
    @conferences = Conference.all
    respond_to do |format|
      # index.html.erb
      format.html      
      # json dump
      format.json do
        render :json => @conferences
      end
    end
  end

  def show
    @conference = Conference.find(params[:id])
    render json: @conference
  end

  def new
    @conference = Conference.new
    render json: @conference
  end

  def create
    @conference = Conference.create(params[:conference])

    if @conference.save
      render json: @conference, status: :created, location: @conference
    else
      render json: @conference.errors, status: :failed
    end
  end

  def update
    @conference = Conference.find(params[:id])

    if @conference.update_attributes(params[:conference])
      render json: @conference, location: @conference
    else
      render json: @conference.errors, status: :failed
    end
  end

  def delete
    @conference = Conference.find(params[:id])

    if @conference.destroy
      render json: @conference
    else
      render json: @conference.errors, status: :failed
    end
  end

end


