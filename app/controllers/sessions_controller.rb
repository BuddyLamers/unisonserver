class SessionsController < ApplicationController

  def index
    # will work for a student or a teacher
    person_id = params[:person_id] || params[:student_id] || params[:teacher_id]
    if person_id
      @sessions = Session.where(person_ids: {"$in" => [Moped::BSON::ObjectId(person_id)]}).desc(:time)
    else
      @sessions = Session.desc(:time)
    end

    respond_to do |format|
      format.html {render :index}
      # json dump
      format.json do
        render :json => @sessions
      end
    end
  end

  def show
    @session = Session.find(params[:id])
    @breaches = @session.breaches
    
    respond_to do |format|
      format.html {render :show}
      format.json {render json: @session}
    end
  end

  def new
    @session = Session.new

    respond_to do |format|
      format.html {render :new}
      format.json {render json: @session}
    end
  end

  def create
    # explain why "session" and not :session later
    @session = Session.new()
    setup_atsession

    # make helper method for use in views
    # session_time = @session.time.to_i
    # seconds_since_epoc += (@session.length * 60)
    # end_time = Time.at(seconds_since_epoc).to_datetime

    respond_to do |format|
      if @session.save
        format.html {render :show, notice: "Session created"}
        format.json {render json: @session, status: :created, location: @session}
      else
        format.html do
          flash[:errors] = @session.errors.full_messages
          render :new, notice: flash[:errors]
        end 
        format.json {render json: @student.errors, status: :failed}
      end
    end

    #not sure why this auth stuff was in here. perhaps accidentally confusing session and sessions
    # respond_to do |format|
      # if user
        
        # session[:user_id] = user.id
        # format.html {redirect_to root_path, notice: "You are logged in as #{user.email}."}
        # format.json {render json: @session, status: :created, location: @session}
      # else
        # format.html {redirect_to new_session_path, alert: "Email or password is invalid."}
        # format.json {render json: @session.errors, status: :failed}
      # end
    # end
  end

  def update

    respond_to do |format|

      format.html do
        @session = Session.find(params[:id])
        @session.is_completed = params[:completed]
        @session.save
        redirect_to sessions_url
      end

      format.json do
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

    end
    
  end

  def destroy
    @session = Session.realize(params[:id])

    respond_to do |format|
      format.html do
        if @session.destroy
          redirect_to sessions_url
        else
          flash[:errors] = @session.errors.full_messages
          redirect_to sessions_url
        end
      end

      format.json do
        if @session.destroy
          render json: @session
        else
          render json: @session.errors, status: :failed
        end   
      end
    end

    
  end

private

  def setup_atsession
    p_s = params["session"]

    datetime = DateTime.civil(p_s["time(1i)"].to_i, p_s["time(2i)"].to_i, p_s["time(3i)"].to_i,
                            p_s["time(4i)"].to_i, p_s["time(5i)"].to_i)
    @session.time = datetime || DateTime.now


    # not being used
    # @session.order = params["session"]["order"]
    @session.length = params["session"]["length"]
    @session.text_title = p_s["text_title"]
    @session.genre = p_s["genre"]
    @session.is_completed = false

    @session.teacher = current_person
    current_person.sessions << @session
    @session.people << current_person
    # if needing to find students by session
    # students = Student.where(section: @session.section)

    p_s["students"].andand.each do |student_option|
      if student_option[1] == "on"
        @session.person_ids << student_option[0]
        @session.student_ids << student_option[0]
      end
    end

    @session.section = params["session"]["section"]
    if @session.section
      students = Student.where(section: @session.section)
      students.each do | s |
        next if @session.people.include?(s)
        @session.people << s
        @session.students << s
      end
    end

    @session.subject = Subject.where(name: params["session"]["subject"]).first
    code = Code.where(id: params["session"]["code"]).first
    @session.code = code
    if @session.code
      @session.is_coded = true
    else
      @session.is_coded = false
    end
  end

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

