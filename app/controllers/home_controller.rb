class HomeController < ApplicationController
  def index
    @title = "Home"
    @teacher = current_user.person
  end
end
