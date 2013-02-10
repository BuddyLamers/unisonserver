class StudentsController < ApplicationController

  def index
    @students = Student.all
    render json: @students
  end

  def show
    @student = Student.find(params[:id])
    render json: @student
  end

  def new
    @student = Student.new
    render json: @student
  end

  def create
    @student = Student.create(params[:student])

    if @student.save
      render json: @student, status: :created, location: @student
    else
      render json: @student.errors, status: :failed
    end
  end

  def update
    @student = Student.find(params[:id])

    if @student.update_attributes(params[:student])
      render json: @student, location: @student
    else
      render json: @student.errors, status: :failed
    end
  end

  def delete
    @student = Student.find(params[:id])

    if @student.destroy
      render json: @student
    else
      render json: @student.errors, status: :failed
    end
  end

end

