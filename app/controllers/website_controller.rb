class WebsiteController < ApplicationController
  include Km
  layout 'website'


  def homepage
  	# make the kiss metrics interface available
  	km_init
  	# get the uesr agent so that the correct extension
  	# can be offered for download
  	@agent = Agent.new(request.env["HTTP_USER_AGENT"])
    if params[:invite_code]
      @invite_code = params[:invite_code]
      cookies.permanent[:invite_code] = { 
        value: @invite_code,
        domain: '.shopofme.com'
      }
      invite = Invite.find_or_create_by_code(params[:invite_code])
      interaction = invite.interactions.where(:user_identifier => cookies[:km_identity], :event_type => "visit").first
      if interaction.nil?
        invite.interactions.new(:user_identifier => cookies[:km_identity], :event_type => "visit", :count => 1, :user_agent => request.env["HTTP_USER_AGENT"]).save
      else
        count = interaction.count + 1
        interaction.update_attributes({
            :count => count,
            :user_agent => request.env["HTTP_USER_AGENT"]
          })
      end
    end

    # if we have an invite code then try and get the model
    # for this code and serve the associated landing page 
    # variant
    if @invite_code
      @invite = Invite.where(code: @invite_code).limit(1).first
      if @invite
        @variant = @invite.landing_page_variant
      end
    end

    @signup = Signup.new
    @signup.invite = @invite

    # if we don't have a variant at this point, load the
    # default one
    @variant ||= LandingPageVariant.find(15)

    @use_inline_chrome_download = @variant.chrome_inline_install

  	# get the top items for display on the homepage
  	base_key = Rails.env + ":top_items:" + 'weekly:' +  Date.today.year.to_s + ':' + Date.today.cweek.to_s
  	the_entries = $redis.zrevrange base_key, 0, -1
    the_entries = the_entries.collect {|ent| ent.to_i}
    @top_items = FullItem.where('id IN (?) AND (selected_price IS NOT NULL) AND (selected_price > 0) AND (image_path IS NOT NULL)',the_entries).limit(6)
    require 'open-uri'
  end
end
