class Dm::FullItemsController < ApplicationController
  layout 'dm'

  def index
    @items = FullItem.where(retailer_id: params[:retailer_id])

    if params[:type] == 'no_gender'
      @items = @items.where(gender: "")
    elsif params[:type] == 'no_image'
      @items = @items.where(image_path: nil)
    elsif params[:type] == 'no_price'
      @items = @items.where(selected_price: nil)
    end

    @items = @items.page(params[:page])

  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
