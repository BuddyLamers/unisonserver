class TeachersController < ApplicationController

  before_filter :require_user

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

  def new
    @user = User.new
    @teacher = Teacher.new
    
    respond_to do |format|
      format.html
      format.json {render json: @teacher}
    end
  end

  # Since we don't have a users_controller, we,'re going to create the user
  # via the teachers and students controllers.
  def create
    @teacher = Teacher.new(params[:teacher])
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        @teacher.user_id = @user.id.to_s
        if @teacher.save
          format.html {redirect_to teacher_path(@teacher), notice: "Teacher created"}
          format.json {render json: @teacher, status: :created, location: @teacher}
        else
          format.html {render 'new'}
          format.json {render json: @teacher.errors, status: :failed}
        end
      else 
        format.html {render 'new'}
        format.json {render json: @user.errors, status: :failed}
      end
    end
  end

  def update
    @teacher = Teacher.find(params[:id])

    respond_to do |format|
      if @teacher.update_attributes(params[:teacher])
        format.html {redirect_to @teacher, notice: "Teacher updated."}
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
  
  private

end

