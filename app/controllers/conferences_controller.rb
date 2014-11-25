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

        @conference.teacher_id = conference_params[:teacher]
          @conference.student_id = conference_params[:student]
          @conference.subject_id = conference_params[:subject_id]

          datetime = DateTime.civil(conference_params["time(1i)"].to_i, conference_params["time(2i)"].to_i, conference_params["time(3i)"].to_i,
                            conference_params["time(4i)"].to_i, conference_params["time(5i)"].to_i)
        @conference.time = datetime
        @conference.is_completed = false
        @conference.notes = conference_params[:notes]

        @conference.save
        redirect_to @conference
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

  def update
    @conference = Conference.realize(params[:id])

    respond_to do |format|

      format.html do
        pcs = params[:code_scores]
        pcs[:notions].length.times do |i|
          code_score = CodeScore.new(
            notion: pcs[:notions][i],
            score: pcs[:scores][i],
            comment: pcs[:comments][i],
            code: Code.find(pcs[:codes][i]),
            conference: @conference).save!
        end

        @conference.is_completed = true
          if @conference.save
            redirect_to @conference
          else

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

    if @conference.destroy
      render json: @conference
    else
      render json: @conference.errors, status: :failed
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


