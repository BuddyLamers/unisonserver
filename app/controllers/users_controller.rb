class UsersController < ApplicationController

  before_filter :require_admin

  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.json do
        render :json => @users
      end
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
      format.json {render json: @user}
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def new
    if params[:person_id]
      @user = User.new(person_id: params[:person_id])
      @user.person = Person.find(params[:person_id])
    else
      @user = User.new
    end

    respond_to do |format|
      format.html
      format.json {render json: @user}
    end
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html {redirect_to users_path, notice: "User created"}
        format.json {render json: @user, status: :created, location: @user}
      else
        format.html {render 'new'}
        format.json {render json: @user.errors, status: :failed}
      end
    end
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html {redirect_to users_path, notice: "User updated."}
        format.json {render json: @user, location: @user}
      else
        format.html {render 'edit'}
        format.json {render json: @user.errors, status: :failed}
      end
    end
  end

  def destroy
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.destroy
        format.html {redirect_to users_path, notice: "Deleted #{@user.email}"}
        format.json {render json: @user}
      else
        format.html {render 'index'}
        format.json {render json: @user.errors, status: :failed}
      end
    end
  end

  private

end

