class Analytics::ActiveInstall < Analytics::AnalyticsBase
	def track(options={})
		if options[:user_id]
			user_key = create_key(Date.today.to_s)
			$redis.zincrby user_key, 1, options[:user_id]
		end
	end

	#@param :: days :: number of days
	def over_period(options={})
		total = 0
		if options[:days]
			(options[:days].to_i.days.ago.to_date..Date.today).each do |day|
				total += $redis.zcard create_key(day.to_s)
				
				#below can be used to get sum of scores
				#total += res.each_slice(2).inject(0) { |i, (j,k)| i += k.to_i }
			end 
		end
		total
	end
end