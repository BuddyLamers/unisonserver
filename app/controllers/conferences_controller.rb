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
    @conference = Conference.find(params[:id])
    render json: @conference
  end

  def new
    @conference = Conference.new
    render json: @conference
  end

  def create
    @conference = Conference.create(params[:conference])

    if @conference.save
      render json: @conference, status: :created, location: @conference
    else
      render json: @conference.errors, status: :failed
    end
  end

  def update
    @conference = Conference.realize(params[:id])

    if params[:code_scores]
      parse_code_scores_hash(params[:code_scores])
    end

    if @conference.update_attributes(params[:conference])
      render json: @conference, location: @conference
    else
      render json: @conference.errors, status: :failed
    end
  end

  def delete
    @conference = Conference.realize(params[:id])

    if @conference.destroy
      render json: @conference
    else
      render json: @conference.errors, status: :failed
    end
  end

private

  def parse_code_scores_hash(code_scores_hash)
    code_scores_hash.each do |code_score_hash|
      code_score = CodeScore.realize(code_score_hash[:id])
      code_score.update_attributes(code_score_hash)
      code_score.conference = @conference
      code_score.save
    end
  end

end


