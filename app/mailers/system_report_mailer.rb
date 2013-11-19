class SystemReportMailer < ActionMailer::Base
  def generic_system_notifier(options)

    @message = options[:message]
    mail(:to => 'ben@stylegauge.com', :subject => options[:subject], :from => "reports@shopofme.com")

  end

  class Preview < MailView
    # Pull data from existing fixtures
    def generic_system_notifier
       SystemReportMailer.generic_system_notifier
    end
  end

end
