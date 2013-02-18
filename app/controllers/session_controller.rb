class SessionController < ApplicationController

  def auth
    user = User.auth(params[:email], params[:password])

    if user
      render json: {token: user.token, teacher: user.person}
    else
      render json: {error: 'failed'}, status: :failed
    end
  end

end

