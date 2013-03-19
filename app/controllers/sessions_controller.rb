class SessionsController < ApplicationController

  before_filter :require_user

  def index
    person_id = params[:person_id] || params[:student_id] || params[:teacher_id]
    if person_id
      @sessions = Session.where(person_ids: {"$in" => [Moped::BSON::ObjectId(person_id)]})
    else
      @sessions = Session.all
    end

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
    @user = User.new

    respond_to do |format|
      format.html
      format.json {render json: @session}
    end
  end

  def create
    @session = Session.new(params[:session])
    user = User.auth(params[:email], params[:password])

    respond_to do |format|
      if user
        session[:user_id] = user.id
        format.html {redirect_to root_path, notice: "You are logged in as #{user.email}."}
        format.json {render json: @session, status: :created, location: @session}
      else
        format.html {redirect_to new_session_path, alert: "Email or password is invalid."}
        format.json {render json: @session.errors, status: :failed}
      end
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

  def destroy
    session[:user_id] = nil
    respond_to do |format|
      format.html {redirect_to root_path, notice: "You have been logged out."}
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

