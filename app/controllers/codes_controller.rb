class CodesController < ApplicationController
  def index
    @codes = Code.all
    render json: @codes
  end

  def show
    @code = Code.find(params[:id])
    render json: @code
  end

  def new
    @code = Code.new
    render json: @code
  end

  def create
    @code = Code.create(params[:code])

    if @code.save
      render json: @code, status: :created, location: @code
    else
      render json: @code.errors, status: :failed
    end
  end

  def update
    @code = Code.find(params[:id])

    if @code.update_attributes(params[:code])
      render json: @code, location: @code
    else
      render json: @code.errors, status: :failed
    end
  end

  def delete
    @code = Code.find(params[:id])

    if @code.destroy
      render json: @code
    else
      render json: @code.errors, status: :failed
    end
  end

end

