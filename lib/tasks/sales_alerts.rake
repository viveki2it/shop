namespace :sales_alerts do
  
  desc "Generate sales alerts"
  task :generate_sales_alerts => :environment do
    User.all.each do |user|
      user.generate_sales_alert
    end
  end

  desc "Sale Alert Emails"
  task :send_sales_alerts => :environment do
    SalesAlert.where("email_sent=?", false).each  do |sales_alert|
      SalesAlertMailer.send_sales_alerts(sales_alert).deliver
      sales_alert.update_attribute(:email_sent, true)
    end
  end
end