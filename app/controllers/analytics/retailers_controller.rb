class Analytics::RetailersController < ApplicationController
  layout 'analytics'
  before_filter :authenticate_admin_user!

  def show
    @retailer = Retailer.find_by_id(params[:id])
    @report = RetailerReport.new.generate_report(@retailer)

  end

end
