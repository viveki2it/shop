class ViewedController < ApplicationController
	include ParamLoaders

  def index
  	load_all_as_instance_vars(params)
  end
end
