class BreachesController < ApplicationController

  def index
    @breaches = Breach.all
    render json: @breaches
  end

  def show
    @Breach = Breach.find(params[:id])
    render json: @breaches
  end

  def new
    @Breach = Breach.new
    render json: @Breach
  end

  def create
    @Breach = Breach.create(params[:Breach])

    if @Breach.save
      render json: @Breach, status: :created, location: @Breach
    else
      render json: @Breach.errors, status: :failed
    end
  end

  def update
    @Breach = Breach.find(params[:id])

    if @Breach.update_attributes(params[:Breach])
      render json: @Breach, location: @Breach
    else
      render json: @Breach.errors, status: :failed
    end
  end

  def delete
    @Breach = Breach.find(params[:id])

    if @Breach.destroy
      render json: @Breach
    else
      render json: @Breach.errors, status: :failed
    end
  end

end


