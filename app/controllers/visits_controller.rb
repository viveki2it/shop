class VisitsController < ApplicationController
  include Km

  def create
  	if params[:site] && params[:user_hash]  && params[:user_hash] != ""
  		the_user = User.find_by_identifier(params[:user_hash])
  		if !the_user
  			the_user = User.new
  			the_user.identifier = params[:user_hash]
  			the_user.save
  		end

      unless the_user.identifier.nil? || the_user.id.nil?
        @the_user = the_user
        km_init

        the_host_name = URI(params[:site]).host
        the_site = Retailer.find_by_domain(the_host_name)

        liked_item = @the_user.visit_site(params[:site])

        KM.record('Visit Supported Site', {'site'=>the_site.domain}) unless !liked_item[:valid_site]
        KM.record('New Item Added To Database') unless !liked_item[:new_item]
        KM.record('Supported Item Visited') unless !liked_item[:valid_item]


        user_agent = Agent.new(request.env["HTTP_USER_AGENT"])
        KM.set({:active_install_browser => user_agent.name})

        begin
          @the_user.last_active = Time.now
          @the_user.last_ip = request.remote_ip
          @the_user.location(true)
        rescue Exception
        end

        render :nothing => true

    		# render :json => the_recs.first(10), :callback => params[:callback]
    		#render :json => Item.all, :callback => params[:callback]
      end
  	end
  end
end
