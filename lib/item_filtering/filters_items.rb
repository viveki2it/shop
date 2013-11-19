module FiltersItems
  # an extension to models which allows them to pass in filters, options
  # and a sent key and returns an active record relation of filtered
  # items
  # base_association - the start of the association chain to filter from
  #   this should begin with FullItem
  # filters - filter hash as generated in param_loaders.rb
  # sent_key - if the returned results are being infinte scrolled then 
  #   need to keep track of which items have been sent since
  #   options[:reset] was last true and only send new ones. If this
  #   param is not nil then this logic will be automatically applied
  # options -
  #   :reset - if true then reset the redis list defined in sent_key
  #     which determined which items have already been sent for this
  #     user
  #   :count - the maximum number of items to return
  def filter_items(base_association, filters, options={}, sent_key=nil)
    # in order to filter by category we need to join to master_categories
    res = base_association.where(:enabled => true)
    res = res.joins(:master_categories)

    #if options[:random] = 'true'
      #res = res.offset(rand(res.count - 100))
    #end

    # we maintain a list of items already sent for the current user to avoid
    # duplication, if reset is true then we're starting from scratch, wipe the
    # list and start again.
    if options[:reset] == "true" && sent_key
			$redis.del(sent_key)
    elsif sent_key
      # if reset is not true then add a filter for any items in the redis list
      # of sent items. the extra -1 is because postgres gets upset if passed
      # the equivilent of NOT IN (NIL) and by upset I mean returns nothing.
      sent_items = $redis.smembers(sent_key).map {|i| i.to_i}
      res = res.where('full_items.id NOT IN (?)',([-1] + sent_items))
    end


    # filter the items by gender, leave it each filter as an association so
    # so we can chain them based on future filters
    if filters[:gender]
      if filters[:gender].kind_of? Array
        filters[:gender] = filters[:gender].first
      end
      if filters[:gender] == 'Men'
        filters[:gender] = 'Male'
      elsif filters[:gender] == 'Women'
        filters[:gender] = 'Female'
      end
      res = res.where('gender = ?',filters[:gender])
    end

    # if any category filters have been specified then apply category filtering to 
    # the items
    if filters[:categories]
      cat_query = []
      filters[:categories].each do |cat|
        cat_query << "(master_categories.id = #{cat})"
      end

      # convert the array of category ors into SQL
      cat_query = cat_query.join(" OR ")

      # append the category query to the association chain and make sure
      # only unique items are returned
      res = res.where(cat_query).select('DISTINCT ON (full_items.id) full_items.*')
    end

    # limit the number of results returned
    res = res.limit(options[:count] || 30)

    # record the items which are being returned in the redist list of sent
    # items
    $redis.sadd sent_key, res.each.map {|item| item.id} unless (res.count == 0 || sent_key.nil?)

    return res

  end
end
