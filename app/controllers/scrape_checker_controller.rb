class ScrapeCheckerController < ApplicationController
  def check
  	# get all of the supported domains as a list
  	if params[:url]
  		the_host_name = URI(params[:url]).host
        the_site = SupportedDomain.find_by_domain(the_host_name)

        if the_site
        	@item = Item.new
        	@item.supported_domain = the_site
        	@item.url = params[:url]
        	@item.extract_data
        	@item.refresh_price
        end
  	end
  end

  def sd_analysis
    @sd = SupportedDomain.all
  end
end
