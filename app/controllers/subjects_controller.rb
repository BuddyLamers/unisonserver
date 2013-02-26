class SubjectsController < ApplicationController

  def index
    @subjects = Subject.all
    
    respond_to do |format|
      format.html
      format.json {render json: @subjects}
    end
  end

  def show
    @subject = Subject.find(params[:id])
    @codes = @subject.codes
    
    respond_to do |format|
      format.html
      format.json {render json: @subject}
    end
  end

  def new
    @subject = Subject.new
    
    respond_to do |format|
      format.html
      format.json {render json: @subject}
    end
  end

  def create
    @subject = Subject.create(params[:subject])

    respond_to do |format|
      if @subject.save
        format.html {redirect_to subjects_path, notice: "Created a new subject: #{@subject.name}."}
        format.json {render json: @subject, status: :created, location: @subject}
      else
        format.html {render 'new', alert: "We were unable to create a new subject."}
        format.json {render json: @subject.errors, status: :failed}
      end
    end
  end
  
  def edit
    @subject = Subject.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def update
    @subject = Subject.find(params[:id])

    respond_to do |format|
      if @subject.update_attributes(params[:subject])
        format.html {redirect_to subjects_path, notice: "Updated #{@subject.name}."}
        format.json {render json: @subject, location: @subject}
      else
        format.html {render 'edit', alert: "Unable to update #{@subject.name}."}
        format.josn {render json: @subject.errors, status: :failed}
      end
    end
  end

  def delete
    @subject = Subject.find(params[:id])

    if @subject.destroy
      render json: @subject
    else
      render json: @subject.errors, status: :failed
    end
  end

  def destroy
    @subject = Subject.find(params[:id])
    
    if @subject.destroy
      redirect_to subjects_path, notice: "Deleted #{@subject.name}."
    else
      render 'index', alert: "Unable to delete #{@subject.name}."
    end
  end
end
