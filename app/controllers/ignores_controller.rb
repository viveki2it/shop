class IgnoresController < ApplicationController
  def create
  	the_user = User.find_by_identifier(params[:user_id])
  	the_item = Item.find(params[:item_id])

  	if the_user && the_item
  		the_user.ignore the_item
  	end

  	respond_to do |format|
  		format.js
  	end

  end
end
