class TeachersController < ApplicationController

  def index
    @teachers = Teacher.all
    render json: @teachers
  end

  def show
    @teacher = Teacher.find(params[:id])
    render json: @teacher
  end

  def new
    @teacher = Teacher.new
    render json: @teacher
  end

  def create
    @teacher = Teacher.create(params[:teacher])

    if @teacher.save
      render json: @teacher, status: :created, location: @teacher
    else
      render json: @teacher.errors, status: :failed
    end
  end

  def update
    @teacher = Teacher.find(params[:id])

    if @teacher.update_attributes(params[:teacher])
      render json: @teacher, location: @teacher
    else
      render json: @teacher.errors, status: :failed
    end
  end

  def delete
    @teacher = Teacher.find(params[:id])

    if @teacher.destroy
      render json: @teacher
    else
      render json: @teacher.errors, status: :failed
    end
  end

end

