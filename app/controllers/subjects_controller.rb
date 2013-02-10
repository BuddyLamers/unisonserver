class SubjectsController < ApplicationController

  def index
    @subjects = Subject.all
    render json: @subjects
  end

  def show
    @subject = Subject.find(params[:id])
    render json: @subject
  end

  def new
    @subject = Subject.new
    render json: @subject
  end

  def create
    @subject = Subject.create(params[:subject])

    if @subject.save
      render json: @subject, status: :created, location: @subject
    else
      render json: @subject.errors, status: :failed
    end
  end

  def update
    @subject = Subject.find(params[:id])

    if @subject.update_attributes(params[:subject])
      render json: @subject, location: @subject
    else
      render json: @subject.errors, status: :failed
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

end

