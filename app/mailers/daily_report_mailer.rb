class DailyReportMailer < ActionMailer::Base
  def analytics
  	@date = Date.today
  	@ai = Analytics::ActiveInstall.new
  	@au = Analytics::EngagedVisitor.new
	invc = Analytics::InviteVisit.new
  	@invite_codes = invc.list_codes
  	@invite_scores = invc.list_scores
  	@invite_downloads = invc.list_downloads
  	@td = Analytics::Downloads.new
  	@ni = Analytics::NewInstall.new
  	@lpc = Analytics::HomepageSignups.new

    mail(:to => 'ben@stylegauge.com,travis@stylegauge.com,huw@stylegauge.com', :subject => "ShopOfMe Daily Analytics", :from => "reports@shopofme.com")

  end

  def data_integrity_report
    @retailers = Retailer.all
    @date = Date.today

    @retailers.sort! { |b,a| a.full_items.where(enabled: false).count <=> b.full_items.where(enabled: false).count  }

    mail(:to => 'ben@shopofme.com,huw@shopofme.com,travis@shopofme.com', :subject => "ShopOfMe Data Integrity Report", :from => "reports@shopofme.com")

  end

  class Preview < MailView
    # Pull data from existing fixtures
    def anlaytics
       DailyReportMailer.analytics
    end

    def data_integrity_report
      DailyReportMailer.data_integrity_report
    end
  end

end
