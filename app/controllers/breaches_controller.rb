class BreachesController < ApplicationController

  def index
    person_id = params[:person_id] || params[:student_id] || params[:teacher_id]
    if person_id
      @breaches = Breach.where(person_ids: {"$in" => [Moped::BSON::ObjectId(person_id)]})
    elsif params[:session_id]
      @breaches = Session.find(params[:session_id]).breaches
    else
      @breaches = Breach.all
    end
    render json: @breaches
  end

  def show
    @breach = Breach.find(params[:id])
    render json: @breach
  end

  def new
    @breach = Breach.new
    render json: @breach
  end

  def create
    respond_to do |format|
      format.html do
        @breach = Breach.new()
        @breach.session_id = params[:breach][:session_id]
        @breach.code_type_id = params[:breach][:code_type_id]
        @breach.code = params[:breach][:code]

        # adds all people present, even if they did not contribute
        @breach.session.people.each do |person|
          @breach.people << person
          person.breaches << @breach
        end

        params[:breach][:code_ids].andand.each do |key, value|
          @breach.code_ids << key if value == "on"
        end

        # # if there are no contributions, skip it.
        # if params[:breach][:contributions].empty?
        #   lash.now[:errors] += "No contributions present"
        #   redirect_to "#{@breach.session_id}"
        # end
        
        # initialize contributions
        params[:breach][:contributions].andand.each_with_index do |text, i|
           
           person_name = params[:breach][:person_ids][i].split(" ")
           person_id = Person.where(fname: person_name[0], lname: person_name[1]).first.id

          new_contribution = Contribution.new(
            text: text,
            time: Time.now,
            breach: @breach,
            person_id: person_id
            )
          if new_contribution.save
            @breach.contribution_ids << new_contribution.id
          else
            # crash something
            raise "contribution did not save"
          end
        end

        @breach.time = Time.now


        if @breach.save
          redirect_to "/sessions/#{@breach.session_id}"
        else
          flash[:errors] = @breach.errors.full_messages
          redirect_to "/sessions/#{@breach.session_id}"
        end

      end
      format.json do
        @breach = Breach.create(params[:breach])
        if @breach.save
          render json: @breach, status: :created, location: @breach
        else
          render json: @breach.errors, status: :failed
        end
      end
    end
  end

    

  def update
    @breach = Breach.find(params[:id])

    if @breach.update_attributes(params[:breach])
      render json: @breach, location: @breach
    else
      render json: @breach.errors, status: :failed
    end
  end

  def destroy
    @breach = Breach.find(params[:id])

    if @breach.destroy
      render json: @breach
    else
      render json: @breach.errors, status: :failed
    end
  end

end


