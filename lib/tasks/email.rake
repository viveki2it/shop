namespace :email do
  desc "Sends Admin Emails"
  task :send_daily_analytics => :environment do
    DailyReportMailer.analytics.deliver
  end

  task :data_integrity_report => :environment do
    DailyReportMailer.data_integrity_report.deliver
  end
end
