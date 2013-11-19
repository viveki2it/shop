class SupportedDomainsController < ApplicationController
  include Km

  def index
  	@domains = SupportedDomain.all
  	@domains_only = []
  	@domains.each {|d| @domains_only << d.domain}
    begin
      # process the tracking stuff here
      if params[:identifier] && (the_user = User.find_or_create_by_identifier(params[:identifier]))
        @the_user = the_user
        km_init
        if ((Time.now - 1.hours) < the_user.created_at) && the_user.invite_code.nil?
          if params[:invite] && params[:invite] != "null" && params[:invite] != "inviteinit"
            the_invite = Invite.find_or_create_by_code(params[:invite])
            the_invite.save
            the_user.invite_code = params[:invite]
            the_user.invite = the_invite
            KM.set({cnf_invite_code: the_user.invite_code})
          end
        end
        if params[:version] && params[:browser]
          the_user.extension_version = "#{params[:browser]}:#{params[:version]}"
        end
        if the_user.last_started_extension.nil?
          # if this is nil then we can assume the extension has never been started before
          # so this is a new download.
          KM.record('New Confirmed Extension Install')
          invite_code = the_user.invite_code ? the_user.invite_code : "None"
          KM.set({cnf_invite_code: invite_code, cnf_version: the_user.extension_version})
          the_user.last_ip = request.remote_ip
          the_user.location
        else
          # if not then this is an existing install
          KM.record('Existing Confirmed Extension Install')
        end
        the_user.last_started_extension = Time.now
        the_user.save
      end
    rescue Exception
      # It's really bad practice to rescue from Exception BUT it's essential
      # that the tracking code can't prevent supported domains from returning
      # valid JSON because this will prevent all new installations of the 
      # extension from doing anything.
    end
  	respond_to do |format|
  		format.json do 
  			render :json => @domains_only, :callback => params[:callback]
  		end
  	end
  end
end
