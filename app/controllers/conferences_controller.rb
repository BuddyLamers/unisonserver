class ConferencesController < ApplicationController

  def index
    if params[:teacher_id]
      @conferences = Teacher.find(params[:teacher_id]).conferences
    elsif params[:student_id]
      @conferences = Student.find(params[:student_id]).conferences
    else
      @conferences = Conference.all
    end

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
    @conference = Conference.find(params[:id]) unless @conference

    respond_to do |format|
      format.html do
        render :show
      end
      format.json do
        render json: @conference
      end
    end
    
  end

  def new
    @conference = Conference.new

    respond_to do |format|
      format.html do
        render :new
      end
      format.json do
        render json: @conference
      end
    end
  end

  def create
    respond_to do |format|
      format.html do
        @conference = Conference.new()

        cp = conference_params

        @conference.teacher_id = conference_params[:teacher]
        @conference.person_ids << conference_params[:teacher]

        cp[:students].each do |student|
          @conference.student_ids << student[0]
          @conference.person_ids << student[0]
        end

          @conference.subject_id = conference_params[:subject_id]

          datetime = DateTime.civil(conference_params["time(1i)"].to_i, conference_params["time(2i)"].to_i, conference_params["time(3i)"].to_i,
                            conference_params["time(4i)"].to_i, conference_params["time(5i)"].to_i)
        @conference.time = datetime
        @conference.is_completed = false
        @conference.notes = conference_params[:notes]

        if @conference.save
          redirect_to edit_conference_url(@conference)
        else
          flash[:errors] = @conference.errors.full_messages
          render :new
        end
        
      end
      format.json do
         @conference = Conference.create(params[:conference])
        if @conference.save
          render json: @conference, status: :created, location: @conference
        else
          render json: @conference.errors, status: :failed
        end
      end
    end

    
  end

  def edit
    @conference = Conference.find(params[:id])
  end

  def update
    @conference = Conference.realize(params[:id])

    respond_to do |format|

      format.html do
        cp = conference_params
       
        @conference.subject_id = conference_params[:subject_id]

        datetime = DateTime.civil(conference_params["time(1i)"].to_i, conference_params["time(2i)"].to_i, conference_params["time(3i)"].to_i,
                            conference_params["time(4i)"].to_i, conference_params["time(5i)"].to_i)
        @conference.time = datetime
        @conference.is_completed = !(conference_params[:is_completed]).nil?
        @conference.notes = conference_params[:notes]
      
        @conference.breach = cp[:breach]
        @conference.known = cp[:known]
        @conference.unknown = cp[:unknown]
        @conference.resolution = cp[:resolution]
        @conference.narrative = cp[:narrative]
        @conference.takeaway = cp[:takeaway]

        if @conference.save
          redirect_to @conference
        else
          flash[:errors] = @conference.errors.full_messages
          render :edit
        end

      end

      format.json do
        if params[:code_scores]
          parse_code_scores_hash(params[:code_scores])
        end

        if @conference.update_attributes(params[:conference])
          render json: @conference, location: @conference
        else
          render json: @conference.errors, status: :failed
        end
      end
    end
  end

  def destroy
    @conference = Conference.realize(params[:id])

    respond_to do |format|
      format.html do
        if @conference.destroy
          redirect_to conferences_url
        else
          flash[:errors] = @conference.errors.full_messages
          redirect_to conferences_url
        end
      end

      format.json do
       if @conference.destroy
        render json: @conference
      else
        render json: @conference.errors, status: :failed
      end
    end
  end

  
end

private

  def parse_code_scores_hash(code_scores_hash)
    code_scores = []

    code_scores_hash.each do |code_score_hash|
      code_score = CodeScore.realize(code_score_hash[:id])
      code_score.update_attributes(code_score_hash)
      code_score.conference = @conference
      code_score.save
      code_scores << code_score
    end

    to_delete = @conference.code_scores - code_score
    to_delete.each(&:destroy)
  end

  def conference_params
    params[:conference]
  end

end


