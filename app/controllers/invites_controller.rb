class InvitesController < ApplicationController

	layout 'shopofme'

	include Km
	
	def show
		@agent = Agent.new(request.env["HTTP_USER_AGENT"])
		km_init
		Analytics::InviteVisit.new.track({:invite_code => params[:invite_code]})
		KM.record('Visited Invite', {'invite_code'=>params[:invite_code], 'invite_browser'=>Agent.new(request.env["HTTP_USER_AGENT"]).name})
	end

  # when a user installs the extension for the first time they are sent
  # to www.domain.com/i/invitecode/accept
  #
  # They are then automatically redirected to my.shopofme.com?invite=sdafasdfas
  # where the invite code is the code extracted from the cookie in the www 
  # subdomain.
  #
  # This is solely to allow invite codes to be shared between the main domain
  # and the my.shopofme.com subdomain so that installs can be linked to an
  # invite code (rather than just download clicks).
  def accept
    
  end

  # /api/v1/tracking/download_button_clicks
  def download_button_clicks
    unless !params[:invite_code].present?
      @invite = Invite.find_or_create_by_code(params[:invite_code])
      download_link_count = @invite.download_button_clicks + 1
      @invite.update_attribute(:download_button_clicks, download_link_count)
      interaction =  @invite.interactions.where(:user_identifier => cookies[:km_identity], :event_type => "click").first
      
      if interaction.nil?
        @invite.interactions.new(:user_identifier => cookies[:km_identity], :event_type => "click", :count => 1).save
      else
        count = interaction.count + 1
        interaction.update_attribute(:count, count)
      end
    end

    render :text => true
  end
end
