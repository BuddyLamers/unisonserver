class SessionsController < ApplicationController

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

    respond_to do |format|
      format.html
      format.json {render json: @session}
    end
  end

  def create
    @session = Session.new(params[:session])

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

      if @session.teacher == nil
        people = Person.where(_id: {"$in" => @session.person_ids})

        people.each do |person|
          @session.update_attribute :teacher_id, person.id if person._type == 'Teacher'
        end
      end

      render json: @session, location: @session
    else
      render json: @session.errors, status: :failed
    end
  end

  def delete
  end

  def destroy
    @session = Session.realize(params[:id])

    if @session.destroy
      render json: @session
    else
      render json: @session.errors, status: :failed
    end
  end

private

  def parse_breaches_hash(breaches_hash)
    new_breaches = []

    breaches_hash.each do |breach_hash|
      breach = Breach.realize(breach_hash[:id])

      if breach_hash[:contributions]
        parse_contributions_hash(breach_hash[:contributions], breach)
        breach_hash.delete(:contributions)
      end

      breach.update_attributes(breach_hash)
      breach.session = @session
      breach.save

      new_breaches << breach
    end

    to_delete = @session.breaches - new_breaches
    to_delete.each(&:destroy)
  end

  def parse_contributions_hash(contributions_hash, breach)
    contribs = []

    contributions_hash.each do |contrib_hash|
      contrib = Contribution.realize(contrib_hash[:id])
      contrib.update_attributes(contrib_hash)
      contrib.breach = breach
      contrib.save

      contribs << contrib
    end

    to_delete = breach.contributions - contribs
    to_delete.each(&:destroy)
  end

end

