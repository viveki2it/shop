class LikesController < ApplicationController
  include ParamLoaders

  def create

  	load_all_as_instance_vars(params)

  	item = Item.find(params[:item_id]) 
    
    if item 
  		@the_user.like item
      @the_user.increment_score
      @the_user.save
  	end

  	load_all_as_instance_vars(params)

  	if params[:silent] == 'true'
  		#return render :nothing => true, :status => 200
  	end
  end

  def destroy
  end
end
