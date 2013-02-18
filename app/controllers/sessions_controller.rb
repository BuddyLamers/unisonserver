class SessionsController < ApplicationController

  before_filter :require_user

  def index
    @sessions = Session.all
    respond_to do |format|
      # index.html.erb
      format.html
      # json dump
      format.json do
        render :json => @sessions
      end
    end
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
    @session = Session.new(params[:session])

    if @session.save
      render json: @session, status: :created, location: @session
    else
      render json: @session.errors, status: :failed
    end
  end

  def update
    @session = Session.realize(params[:id])

    if params[:breaches]
      parse_breaches_hash(params[:breaches])
    end

    if @session.update_attributes(params[:session])
      render json: @session, location: @session
    else
      render json: @session.errors, status: :failed
    end
  end

  def delete
    @session = Session.realize(params[:id])

    if @session.destroy
      render json: @session
    else
      render json: @session.errors, status: :failed
    end
  end

private

  def parse_breaches_hash(breaches_hash)
    breaches_hash.each do |breach_hash|
      breach = Breach.realize(breach_hash[:id])

      if breach_hash[:contributions]
        parse_contributions_hash(breach_hash[:contributions], breach)
        breach_hash.delete(:contributions)
      end

      breach.update_attributes(breach_hash)
      breach.session = @session
      breach.save
    end
  end

  def parse_contributions_hash(contributions_hash, breach)
    contributions_hash.each do |contrib_hash|
      contrib = Contribution.realize(contrib_hash[:id])
      contrib.update_attributes(contrib_hash)
      contrib.breach = breach
      contrib.save
    end
  end

end

