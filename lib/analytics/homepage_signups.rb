class Analytics::HomepageSignups < Analytics::AnalyticsBase

	def track(options={})
		if options[:visit]
			user_key = create_key("visit:"+Date.today.to_s)
			all_key = create_key('visit:all')
			
		elsif options[:conversion]
			user_key = create_key("conversion:"+Date.today.to_s)
			all_key = create_key('conversion:all')
		end
		$redis.incr user_key
		$redis.incr all_key
	end

	#@param :: days :: number of days
	def over_period(options={})
		total_visits = 0
		total_conversions = 0
		if options[:days]
			(options[:days].to_i.days.ago.to_date..Date.today).each do |day|
				vst = $redis.get create_key('visit:' + day.to_s)
				cnv = $redis.get create_key('conversion:' + day.to_s)
				total_visits += vst ? vst.to_i : 0
				total_conversions += cnv ? cnv.to_i : 0
				
				#below can be used to get sum of scores
				#total += res.each_slice(2).inject(0) { |i, (j,k)| i += k.to_i }
			end 
		end
		total_conversions > 0 ? (total_conversions.to_f/total_visits.to_f) : 0
	end

end