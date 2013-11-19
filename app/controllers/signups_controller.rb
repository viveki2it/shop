class SignupsController < ApplicationController
  include Km

  def create

  	@signup = Signup.new params[:signup]
  	@signup.save

  end
end
