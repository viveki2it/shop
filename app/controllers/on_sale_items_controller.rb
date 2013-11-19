class OnSaleItemsController < ApplicationController
  def index
    @on_sale_items = OnSaleItem.page(params[:page]).per(20)
  end
end
