class Analytics::Downloads < Analytics::AnalyticsBase
	def inc_keys(subset, options)
		period_key = create_key(subset+Date.today.to_s)
		all_key = create_key(subset+'all')

		if options[:type]
			source_all_key = create_key(subset+options[:type] + ':all')
			source_period_key =  create_key(subset+options[:type] + ":" + Date.today.to_s)
			$redis.incr source_period_key
			$redis.incr source_all_key
		end

		$redis.incr period_key
		$redis.incr all_key
	end

	def track(options={})
		if (options[:update] && options[:update == false]) || !options[:update]
			#track downloads
			inc_keys('',options)
			if options[:invite_code]
				inc_keys('invite:'+options[:invite_code]+':',options)
			end
		else
			#track updates
			inc_keys('update:',options)
		end

	end

	def over_period(options={})
		total = 0
		if !options[:variant] 
			options[:variant] = ''
		else
			options[:variant] = options[:variant] + ':'
		end
		if options[:days]
			(options[:days].to_i.days.ago.to_date..Date.today).each do |day|
				if options[:type]
					total += ($redis.get create_key(options[:variant] + options[:type] + ":" + day.to_s)).to_i || 0
				else
					total += ($redis.get create_key(options[:variant] + day.to_s)).to_i || 0
				end
			end 
		end
		total
	end

	def total(options={})
		total = 0
		if options[:type]
			total = $redis.get create_key(options[:type] + ':all')
		else
			total = $redis.get create_key('all')
		end
		total
	end
end