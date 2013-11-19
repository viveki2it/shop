class Analytics::UsersController < ApplicationController
  layout 'analytics'

  def show
    @user = User.find_by_identifier(params[:id])
  end
end
