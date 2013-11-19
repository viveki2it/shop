class Api::V1::TopItemsController < ApplicationController
	respond_to :json

	def index
		valid_periods = ['daily','weekly','monthly','all_time']

		period =  params[:period] || 'weekly'
		period = "weekly" if !valid_periods.include?(period) 

		base_key = Rails.env + ":top_items:"
    case period
			when "daily"
				the_key = base_key + 'daily:' +  Date.today.to_s
			when "weekly"
				the_key = base_key + 'weekly:' +  Date.today.year.to_s + ':' + Date.today.cweek.to_s
			when "monthly"
				the_key = base_key + 'monthly:' +  Date.today.year.to_s + ':' + Date.today.month.to_s
			when "all_time"
				the_key = base_key + 'all_time'
    end

		the_entries = $redis.zrevrange the_key, 0, -1
		the_entries = the_entries.collect {|ent| ent.to_i}

		@top_items = FullItem.where('id IN (?)',the_entries).limit(50)

	end
end
