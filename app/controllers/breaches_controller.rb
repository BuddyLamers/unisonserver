class BreachesController < ApplicationController

  def index
    @breaches = Breach.all
    render json: @breaches
  end

  def show
    @breach = Breach.find(params[:id])
    render json: @breaches
  end

  def new
    @breach = Breach.new
    render json: @breach
  end

  def create
    @breach = Breach.create(params[:breach])

    if @breach.save
      render json: @breach, status: :created, location: @breach
    else
      render json: @breach.errors, status: :failed
    end
  end

  def update
    @breach = Breach.find(params[:id])

    if @breach.update_attributes(params[:breach])
      render json: @breach, location: @breach
    else
      render json: @breach.errors, status: :failed
    end
  end

  def delete
    @breach = Breach.find(params[:id])

    if @breach.destroy
      render json: @breach
    else
      render json: @breach.errors, status: :failed
    end
  end

end


