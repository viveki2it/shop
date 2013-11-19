class Api::V1::LikesController < ApplicationController
	include ParamLoaders

  def create

  	# debugger
  	load_all_as_instance_vars(params)
  	item = FullItem.find(params[:item_id]) 
    if item
  		@the_user.like item
      @the_user.increment_score
      @the_user.save
    end

    return render :nothing => true, :status => 200
  end
end
