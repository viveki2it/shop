class RecommendationsController < ApplicationController

	include ParamLoaders

	def whoami
	end

	def index
		load_all_as_instance_vars(params)
		# if the param b is set then this is coming from the extension button
		# track this and then redirect the user to /. Prevents people from
		# bookmarking the link with the tracking param in it and so skewing the 
		# stats

		if params[:b]
			Analytics::EngagedVisitor.new.track({:b => params[:b]})
			flash[:js] = "_kmq.push(['record', 'Visit my.shopofme.com via button']);"
			return redirect_to '/'
		elsif params[:identifier]
			Analytics::EngagedVisitor.new.track({:user_id => params[:identifier]})
		end
		
		respond_to do |format|
			format.html
			format.js
		end
	end
end
