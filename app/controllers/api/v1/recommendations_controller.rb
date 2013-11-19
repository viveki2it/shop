class Api::V1::RecommendationsController < ApplicationController

	include ParamLoaders

	respond_to :json

	def index
		load_all_as_instance_vars(params)
		respond_with @recommendations
	end
end
