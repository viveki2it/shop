class BackboneAppController < ApplicationController
  layout "shopofme_backbone"
  include ParamLoaders

  def show
		params[:reset_page] = "true"
    @invite_code = cookies[:invite_code]
    @campaign_identifier = params[:campaign_identifier]
    if @campaign_identifier == 'su'
      @show_intro = true
    end
    load_all_as_instance_vars(params)
    if params[:b]
      flash[:js] = "_kmq.push(['record', 'Visit my.shopofme.com via button']);"
      return redirect_to '/'
    end
  end
  
end
