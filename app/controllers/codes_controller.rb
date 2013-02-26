class CodesController < ApplicationController
  def index
    @codes = Code.all
    
    respond_to do |format|
      format.html
      format.json {render json: @codes}
    end
  end

  def show
    @code = Code.find(params[:id])
    render json: @code
  end

  def new
    @code = Code.new
    
    respond_to do |format|
      format.html
      format.json {render json: @code}
    end
  end

  def create
    @code = Code.new(params[:code])

    respond_to do |format|
      if @code.save
        format.html {redirect_to codes_path, notice: "Created #{@code.name} code."}
        format.json {render json: @code, status: :created, location: @code}
      else
        format.html {render 'new', alert: "Unable to create code."}
        format.json {render json: @code.errors, status: :failed}
      end
    end
  end
  
  def edit
    @code = Code.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end

  def update
    @code = Code.find(params[:id])

    respond_to do |format|
      if @code.update_attributes(params[:code])
        format.html {redirect_to codes_path, notice: "Updated #{@code.name}."}
        format.json {render json: @code, location: @code}
      else
        format.html {render 'edit', alert: "Unable to update #{@code.name}."}
        format.json {render json: @code.errors, status: :failed}
      end
    end
  end

  def delete
    @code = Code.find(params[:id])

    if @code.destroy
      render json: @code
    else
      render json: @code.errors, status: :failed
    end
  end
  
  def destroy
    @code = Code.find(params[:id])
    
    if @code.destroy
      redirect_to codes_path, notice: "Deleted #{@code.name} code."
    else
      render 'index', alert: "Unable to delete #{@code.name}."
    end
  end

end

