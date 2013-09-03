class TeachersController < ApplicationController

  before_filter :require_admin

  def index
    @teachers = Teacher.all
    respond_to do |format|
      format.html
      format.json do
        render :json => @teachers
      end
    end
  end

  def show
    @teacher = Teacher.find(params[:id])

    respond_to do |format|
      format.html
      format.json {render json: @teacher}
    end
  end

  def edit
    @teacher = Teacher.find(params[:id])

    respond_to do |format|
      format.html
      format.json {render json: @teacher}
    end
  end

  def new
    # we need another way to make accounts
    # @user = User.new
    @teacher = Teacher.new

    respond_to do |format|
      format.html
      format.json {render json: @teacher}
    end
  end

  def create
    @teacher = Teacher.new(params[:teacher])

    respond_to do |format|
      if @teacher.save
        format.html {redirect_to teachers_path, notice: "Teacher created"}
        format.json {render json: @teacher, status: :created, location: @teacher}
      else
        format.html {render 'new'}
        format.json {render json: @teacher.errors, status: :failed}
      end
    end
  end

  def update
    @teacher = Teacher.find(params[:id])

    respond_to do |format|
      puts params[:teacher]
      puts 'hi'
      if @teacher.update_attributes(params[:teacher])
        format.html {redirect_to edit_teacher_path(@teacher), notice: "Teacher updated."}
        format.json {render json: @teacher, location: @teacher}
      else
        format.html {render 'edit'}
        format.json {render json: @teacher.errors, status: :failed}
      end
    end
  end

  def destroy
    @teacher = Teacher.find(params[:id])

    respond_to do |format|
      if @teacher.destroy
        format.html {redirect_to teachers_path, notice: "Deleted #{@teacher.fname} #{@teacher.lname}."}
        format.json {render json: @teacher}
      else
        format.html {render 'index'}
        format.json {render json: @teacher.errors, status: :failed}
      end
    end
  end

  def csv
    CSV.foreach(params[:csv].path, {
        headers: :first_row
      }) do |row|
        attrs = {
          name: row[0]
        }

        name = attrs[:name].split(' ')

        teacher = Teacher.where(fname: name[0], lname: name[1]).first
        Teacher.create(fname: name[0], lname: name[1]) unless teacher
    end

    redirect_to teachers_path
  end

end

