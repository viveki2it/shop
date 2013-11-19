class Analytics::NewInstall < Analytics::AnalyticsBase
	def track
		today_key = create_key(Date.today.to_s)
		all_key = create_key('all')
		$redis.incr today_key
		$redis.incr all_key
	end

	#@param :: days :: number of days
	def over_period(options={})
		total = 0
		if options[:days]
			(options[:days].to_i.days.ago.to_date..Date.today).each do |day|
				total += ($redis.get create_key(day.to_s)).to_i || 0
			end 
		end
		total
	end

	def total
		total = $redis.get create_key('all')
	end
end