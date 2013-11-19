class Analytics::NewItems < Analytics::AnalyticsBase
	def over_period(options={})
		the_date = Date.today - options[:days].to_i.days
		Item.where('created_at > ?',the_date).count
	end

	def total
		Item.all.count
	end
end