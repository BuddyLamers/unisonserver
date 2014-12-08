require 'csv'

class CodesController < ApplicationController

  before_filter :require_admin, only: [:create, :update, :destroy, :csv]

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

  def csv
    # the app needs to skip an entry if there is no text... 
    # this means the "name" is just a category marker.

    # model validations are needed... this is too likely to
    # to screw up data right now, so it shouldn't be used.
    topics = {}
    subjects = {}
    code_types = {}

    CSV.foreach(params[:csv].path, {
        headers: :first_row
      }) do |row|
        attrs = {
          subject: row[0],
          name: row[1],
          text: row[2],
          year: row[3],
          code_type: row[4]
        }

        info = attrs[:name].split('.')

        if !subjects[attrs[:subject]]
          subject = Subject.where(name: attrs[:subject]).first
          subject = Subject.create(name: attrs[:subject]) unless subject
          subjects[attrs[:subject]] = subject
        end

        attrs[:subject] = subjects[attrs[:subject]]

        if !code_types[attrs[:code_type]]
          code_type = CodeType.where(name: attrs[:code_type]).first
          code_type = CodeType.create(name: attrs[:code_type]) unless code_type
          code_types[attrs[:code_type]] = code_type
        end

        attrs[:code_type] = code_types[attrs[:code_type]]

        code = Code.where(name: attrs[:name]).first

        if code
          code.update_attributes(attrs)
        else
          code = Code.create(attrs)
        end

        puts code.attributes
        puts code.errors.full_messages
    end

    redirect_to codes_path
  end

end

