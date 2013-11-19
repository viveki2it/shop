class Api::V1::HistoryController < ApplicationController

	include ParamLoaders

	respond_to :json

	def index
		
    start_time = Time.now
    @the_user = load_user(params)
		filtered_history = []
    if @the_user
      rec_key = Rails.env + ":sent_history:" + @the_user.id.to_s 
      raw_history = @the_user.recorded_likes.order('recorded_date DESC');
      if params[:reset_page]
        $redis.del(rec_key)
      end
			raw_history.each do |item|

        if item.full_item && !$redis.sismember(rec_key,item.full_item.id) && filtered_history.length <= 40
          filtered_history << item.full_item
					$redis.sadd(rec_key, item.full_item.id)
        end
			end

			@history = filtered_history
    end

    end_time = Time.now
		respond_with @history
	end
end
