class Api::V1::ItemsController < ApplicationController


	respond_to :json

	def show
		@item = Item.find(params[:id])
		respond_with @item
	end
end
