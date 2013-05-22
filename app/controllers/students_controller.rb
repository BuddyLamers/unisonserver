class StudentsController < ApplicationController

  before_filter :require_user

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
    @user = User.new
    @student = Student.new

    respond_to do |format|
      format.html
      format.json {render json: @student}
    end
  end

  # Since we don't have a users_controller, we,'re going to create the user
  # via the students and students controllers.
  def create
    @student = Student.new(params[:student])
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        @student.user_id = @user.id.to_s
        if @student.save
          format.html {redirect_to student_path(@student), notice: "Teacher created"}
          format.json {render json: @student, status: :created, location: @student}
        else
          format.html {render 'new'}
          format.json {render json: @student.errors, status: :failed}
        end
      else
        format.html {render 'new'}
        format.json {render json: @user.errors, status: :failed}
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
        format.html {redirect_to @student, notice: "Teacher updated."}
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

  private

end

