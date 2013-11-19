class RecentItemsController < ApplicationController
	def index
		if params[:identifier]
			the_user = User.find_by_identifier(params[:identifier])
			if the_user
				raw_history = the_user.liked.reverse
				filtered_history = []
				raw_history.each do |item|
					(filtered_history << item) unless item.supported_domain.dont_display
				end
				@history = Kaminari.paginate_array(filtered_history).page(params[:page]).per(8)
			else
				@temporary_recommendations = []
			end
		end
		respond_to do |format|
			format.html
			format.js
		end
	end
end
