class Analytics::ButtonVisit < Analytics::AnalyticsBase

	#@param :: days :: number of days
	def over_period(options={})
		total = 0
		if options[:days]
			(options[:days].to_i.days.ago.to_date..Date.today).each do |day|
				#total = $redis.zcard create_key(day.to_s)
				
				#below can be used to get sum of scores
				res = $redis.zrange create_custom_key('button:'+day.to_s, 'Analytics::EngagedVisitor'), 0, -1, {withscores:true}
				total += res.each_slice(2).inject(0) { |i, (j,k)| i += k.to_i }
			end
		end
		total
	end
end