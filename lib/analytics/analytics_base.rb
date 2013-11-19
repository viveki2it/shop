class Analytics::AnalyticsBase
	def track
	end

	def raw_output
	end

	def one_liner_output
	end

	def create_key(key)
		Rails.env + ":" + self.class.name + ":" + key
	end

	def create_custom_key(key, custom_key)
		Rails.env + ":" + custom_key + ":" + key
	end
end