class ContributionsController < ApplicationController

  def index
    @contributions = Contribution.all
    render json: @contributions
  end

  def show
    @contribution = Contribution.find(params[:id])
    render json: @contribution
  end

  def new
    @contribution = Contribution.new
    render json: @contribution
  end

  def create
    @contribution = Contribution.create(params[:contribution])

    if @contribution.save
      render json: @contribution, status: :created, location: @contribution
    else
      render json: @contribution.errors, status: :failed
    end
  end

  def update
    @contribution = Contribution.find(params[:id])

    if @contribution.update_attributes(params[:contribution])
      render json: @contribution, location: @contribution
    else
      render json: @contribution.errors, status: :failed
    end
  end

  def delete
    @contribution = Contribution.find(params[:id])

    if @contribution.destroy
      render json: @contribution
    else
      render json: @contribution.errors, status: :failed
    end
  end

end

