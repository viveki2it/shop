class Dm::RetailersController < ApplicationController
  before_filter :authenticate_admin_user!
  layout 'dm'

  def index
    @retailers = Retailer.where(supported_for_sales: true).order('name asc').all
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
    @retailer = Retailer.find(params[:id])
    @normal_item = FullItem.new
    @sale_item = FullItem.new
  end

  # when commit is set to Preview rather than Save
  # this action will accept an update hash of a retailer as well as two
  # item urls (params[:sale_item_url] and params[:normal_item_url], create (but
  # don't save) an updated version of the retailer (in @retailer) and scrape
  # each of the item urls (@normal_item, @sale_item) using Retailer.scrape so that
  # the results of the current update can be previewed without creating any 
  # database entries
  def update
    # if this is a preview action then create a temp entry and render update js
    # with preview items
    if params[:commit] == 'Preview'
      original_retailer = Retailer.find(params[:id])

      # create a new retailer with the same attributes of the original then update
      # it from the supplied hash.
      @retailer = Retailer.new(original_retailer.attributes)
      @retailer.assign_attributes(params[:retailer])

      @normal_item = Retailer.scrape(@retailer.normal_item_url, @retailer)
      @sale_item = Retailer.scrape(@retailer.sale_item_url, @retailer)
      render 'preview'
    else
      @retailer = Retailer.find(params[:id])
      @retailer.update_attributes(params[:retailer])
      if @retailer.save
        render 'update'
      else
        render 'edit'
      end
    end
  end

  def destroy
    @retailer = Retailer.find(params[:id])
    @retailer.destroy
    redirect_to dm_retailers_path
  end

end
