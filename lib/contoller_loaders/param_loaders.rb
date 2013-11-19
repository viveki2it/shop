module ParamLoaders
	include Km

	def construct_filter_hash(params)
		selected_categories = []
		if params[:filter] && params[:filter][:category] && (params[:startup] != 'true')
			if params[:filter][:category] == '-1'
				selected_categories=MasterCategory.all.map {|x| x.id}
			else
				selected_categories=MasterCategory.where(:id => params[:filter][:category]).to_a.collect {|x| x.id }
			end
		else
			selected_categories=MasterCategory.all.map {|x| x.id}
		end
		if params[:filter] && params[:filter][:gender]
			gender = [params[:filter][:gender]]
      cookies.permanent[:selected_gender] = params[:filter][:gender]
		else
      if cookies[:selected_gender]
        gender = cookies[:selected_gender]
      else
        gender = ['Women']
      end
		end

		{:gender => gender , :categories => selected_categories}
	end

	def load_user(params) 
		if params[:identifier]
			the_user = User.find_by_identifier(params[:identifier])
			if the_user.nil?
				the_user = User.new
	  			the_user.identifier = params[:identifier]
	  			the_user.save
	  		end
		elsif params[:user_id]
			the_user = User.find(params[:user_id])
		else 
			the_user = User.new
		end

		the_user
	end

	def get_category_list(options={})
		if options[:gender] && (options[:gender] == 'Men')
			query = "(master_categories.name NOT IN ('Men','Women')) AND (only_show_to <>'Women' OR only_show_to IS NULL)"
		elsif options[:gender] && (options[:gender] == 'Women')
			query = "(master_categories.name NOT IN ('Men','Women')) AND (master_categories.only_show_to <> 'Men' OR only_show_to IS NULL)"
		else
			query = "master_categories.name NOT IN ('Men','Women')"
		end
		MasterCategory.where(query)
	end

	def load_all_as_instance_vars(params)
		@the_user = load_user(params)
		@filters = construct_filter_hash(params)
		@recommendations = @the_user.recs(@filters, {:count => 30, :reset=>params[:reset_page]})
		@all_categories = get_category_list({:gender => @filters[:gender][0]})
	end
end
