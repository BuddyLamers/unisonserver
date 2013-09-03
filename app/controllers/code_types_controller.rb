class CodeTypesController < ApplicationController

  before_filter :require_admin, only: [:create, :update, :destroy, :csv]

  def index
    @code_types = CodeType.all
    render json: @code_types
  end

  def show
    @code_type = CodeType.find(params[:id])
    render json: @code_type
  end

  def new
    @code_type = CodeType.new
    render json: @code_type
  end

  def create
    @code_type = CodeType.create(params[:code_type])

    if @code_type.save
      render json: @code_type, status: :created, location: @code_type
    else
      render json: @code_type.errors, status: :failed
    end
  end

  def update
    @code_type = CodeType.find(params[:id])

    if @code_type.update_attributes(params[:code_type])
      render json: @code_type, location: @code_type
    else
      render json: @code_type.errors, status: :failed
    end
  end

  def delete
    @code_type = CodeType.find(params[:id])

    if @code_type.destroy
      render json: @code_type
    else
      render json: @code_type.errors, status: :failed
    end
  end

end

