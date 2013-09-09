class StudentsController < ApplicationController

  before_filter :require_admin, only: [:create, :update, :destroy, :csv]

  def index
    @students = Student.all
    respond_to do |format|
      format.html
      format.json do
        render :json => @students
      end
    end
  end

  def show
    @student = Student.find(params[:id])

    respond_to do |format|
      format.html
      format.json {render json: @student}
    end
  end

  def new
    @student = Student.new

    respond_to do |format|
      format.html
      format.json {render json: @student}
    end
  end

  def create
    @student = Student.new(params[:student])

    respond_to do |format|
      if @student.save
        format.html {redirect_to students_path, notice: "Student created"}
        format.json {render json: @student, status: :created, location: @student}
      else
        format.html {render 'new'}
        format.json {render json: @student.errors, status: :failed}
      end
    end
  end

  def edit
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.html {redirect_to edit_student_path(@student), notice: "Teacher updated."}
        format.json {render json: @student, location: @student}
      else
        format.html {render 'edit'}
        format.json {render json: @student.errors, status: :failed}
      end
    end
  end

  def destroy
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.destroy
        format.html {redirect_to students_path, notice: "Deleted #{@student.fname} #{@student.lname}."}
        format.json {render json: @student}
      else
        format.html {render 'index'}
        format.json {render json: @student.errors, status: :failed}
      end
    end
  end

  def csv
    CSV.foreach(params[:csv].path, {
        headers: :first_row
      }) do |row|
        attrs = {
            fname: row[0],
            lname: row[1],
            section: row[3]
        }

        student = Student.where(fname: fname, lname: lname)
        Student.create(fname: fname, lname: lname, section: section) unless student
        
    end

    redirect_to students_path
  end

end

