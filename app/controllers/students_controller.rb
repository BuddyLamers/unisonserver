class StudentsController < ApplicationController

  before_filter :require_admin, only: [:create, :update, :destroy, :csv]

  def index
    @students = Student.asc(:section)
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
      format.html {render :show}
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
    # TEMPORARY

    # should default to unison as school
    CSV.foreach(params[:csv].path, {
        headers: :first_row
      }) do |row|
        Student.create(fname: row[0].titleize, lname: row[1].titleize, school: row[2].titleize, section: row[3])
        
    end

    # add student to all teachers which have their section.
    # this needs to work whether student or teacher csv is uploaded first. Lots of ifs

    redirect_to students_path
  end

end

