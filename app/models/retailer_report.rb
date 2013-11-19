class RetailerReport < ActiveRecord::Base
  attr_accessible :data, :slug

  def generate_report(retailer,period=90)
    ref = Date.today
    likes = likes_in_this_period(period,ref,retailer.id)
    items = items_in_this_period(likes)
    users = users_in_this_period(likes)

    data = {}
    data[:period] = period
    
    data[:views_this_period] = likes.count
    data[:users_in_this_period] = users.uniq.count
    data[:items_in_this_period] = items.uniq.count
    data[:view_distribution] = view_distribution(items.uniq,period,ref)
    data[:popular] = most_popular_items(items.uniq,period,ref).last(10)
   
    data

  end

  def likes_in_this_period(period,ref,retailer_id)
    likes = RecordedLike.where('recorded_date > ? AND recorded_date < ?',(ref - period.days),ref)
    likes.select do |like|
      like.full_item.retailer_id == retailer_id
    end
  end

  def items_in_this_period(likes)
    likes.collect {|like| like.full_item }
  end

  def users_in_this_period(likes)
    likes.collect {|like| like.user }
  end

  def view_distribution(items,period,ref)
    dist = {}
    items.each do |item|
      count = item.recorded_likes.where('recorded_date > ? AND recorded_date < ?',(ref - period.days),ref).count
      dist[count] = (dist[count].nil? ? 1 : dist[count] + 1)
    end
    dist.sort_by { |count, freq| freq }
  end

  def most_popular_items(items,period,ref)
    view_counts = {} 
    items.each do |item|
      count = item.recorded_likes.where('recorded_date > ? AND recorded_date < ?',(ref - period.days),ref).count
      view_counts[item] = (view_counts[item].nil? ? 1 : view_counts[item] + 1)
    end

    view_counts.sort_by {|item, views| views }


  end

end
