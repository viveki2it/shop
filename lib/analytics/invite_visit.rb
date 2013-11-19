class Analytics::InviteVisit < Analytics::AnalyticsBase
	def track(options={})
		if options[:invite_code]
			total_key = create_key('all')
			user_key = create_key(Date.today.to_s)
			$redis.zincrby user_key, 1, options[:invite_code]
			$redis.zincrby total_key, 1, options[:invite_code]
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

	def total_over_period(options={})
		total = 0
		if options[:days]
			(options[:days].to_i.days.ago.to_date..Date.today).each do |day|
				#total += $redis.zcard create_key(day.to_s)
				
				#below can be used to get sum of scores
				total += res.each_slice(2).inject(0) { |i, (j,k)| i += k.to_i }
			end 
		end
		total
	end

	def list_codes(options={})
		the_codes = $redis.zrevrange create_key('all'), 0, -1
	end

	def list_scores(options={})
		the_codes = $redis.zrevrange create_key('all'), 0, -1,{withscores:true}
		the_codes.values_at(* the_codes.each_index.select {|i| i.odd?})
	end

	def list_downloads(options={})
		the_codes = list_codes

		downloads = []
		download_tracker = Analytics::Downloads.new

		the_codes.each do |code|
			downloads << download_tracker.total({:type => 'invite:' + code})
		end
		downloads
	end
end