class RegistrationsController < ApplicationController
  include Km
  layout 'website'

  def new
  end

  def create
    km_init

    if params[:email] && params[:ident] && !params[:email].empty? && !params[:ident].empty?
      @user = User.find_or_create_by_identifier(params[:ident].to_s)
      @user.email = params[:email]
      @user.tracking_code = cookies[:km_identity]
      @user.last_started_extension = Time.now
      
      if cookies[:invite_code]
        @user.invite = Invite.find_or_create_by_code(cookies[:invite_code])
      end

      if @user.save
        redirect_to confirm_registration_path
      else
        render 'new'
      end
    elsif params[:email].empty?
      flash.now[:error] = 'please enter a valid email address'
      render 'new'
    else
      redirect_to '/'
    end
  end

  def confirm
  end
end
