class PagesController < ApplicationController
  layout 'website'
  before_filter :get_agent

  def privacy
    @title = "Privacy | Shop Of Me"
  	@the_sites = SupportedDomain.all
  end

  def tfi_privacy
    @title = "Privacy | The Fashion Intern"
    @the_sites = SupportedDomain.all
  end

  def about
    @title = "About | Shop Of Me"
  end

  def get_agent
    @agent = Agent.new(request.env["HTTP_USER_AGENT"])
  end
end
