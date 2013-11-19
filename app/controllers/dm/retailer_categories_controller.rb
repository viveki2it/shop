class Dm::RetailerCategoriesController < ApplicationController
  layout 'dm'
  def index
    @retailer = Retailer.find(params[:retailer_id])
    @categories = @retailer.retailer_categories
    @mcs = MasterCategory.all.unshift(MasterCategory.new)
  end

  def update
    @retailer = Retailer.find(params[:retailer_id])
    @retailer.retailer_categories.each do |rc|
      if params[rc.name]
        mc = nil
        if params[rc.name][:master_category] != ""
           mc = MasterCategory.find(params[rc.name][:master_category])
        end
        rc.master_category = mc
        rc.save
      end
    end

    redirect_to dm_retailer_retailer_categories_path
  end
end
