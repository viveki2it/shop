class MobileIgnoresController < ApplicationController
  def create
  	@user = User.find_by_identifier params[:user_id]
  	@item = Item.find_by_id params[:item_id]
  	@user.ignore @item

  	if @user  && !@user.recommendations.empty?
  		raw_other_items = @user.recommendations
  	else
  		raw_other_items = Item.find(:all, :order => 'random()' ,:limit=>5)
  	end
				
	@other_people_are_viewing = []
	raw_other_items.each do |rec|
		if rec.image_link && rec.image_link.last != '/' && !@user.likes?(rec) && !@user.ignored?(rec) && @other_people_are_viewing.length < 12
			@other_people_are_viewing << rec
		end
	end

  	item = @other_people_are_viewing.first

	if item.image_link.first == '/' && item.image_link[1]!= '/'
		item.image_link = "http://" + item.supported_domain.domain + '/' + item.image_link
	end

  	respond_to do |format|
  		format.html
  		format.json do
  			render :json => item.to_json
  		end
  	end
  end
end
