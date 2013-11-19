class Analytics::NewVisits < Analytics::AnalyticsBase
	def over_period(options={})
		the_date = Date.today - options[:days].to_i.days
		Visit.where('created_at > ?',the_date).count
	end

	def total
		Visit.all.count
	end
end