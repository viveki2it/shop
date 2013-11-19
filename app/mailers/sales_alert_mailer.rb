class SalesAlertMailer < ActionMailer::Base
  default from: "reports@shopofme.com"

  def send_sales_alerts(sales_alert)
    @full_items = sales_alert.full_items_sales_alerts
    mail(:to => 'ben@shopofme.com', :subject => "Sales Alert - #{sales_alert.user.identifier}")
  end
end
