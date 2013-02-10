class SessionsController < ApplicationController

  def index
    @sessions = Session.all
    render json: @sessions
  end

  def show
    @session = Session.find(params[:id])
    render json: @session
  end

  def new
    @session = Session.new
    render json: @session
  end

  def create
    @session = Session.create(params[:session])

    if @session.save
      render json: @session, status: :created, location: @session
    else
      render json: @session.errors, status: :failed
    end
  end

  def update
    @session = Session.find(params[:id])

    if @session.update_attributes(params[:session])
      render json: @session, location: @session
    else
      render json: @session.errors, status: :failed
    end
  end

  def delete
    @session = Session.find(params[:id])

    if @session.destroy
      render json: @session
    else
      render json: @session.errors, status: :failed
    end
  end

end

