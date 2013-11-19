namespace :rec do
  desc "Imports Likes from RecommendableLikes table"
  task :import_likes => :environment do
    RecommendableLike.all.each do |like|
      begin
        the_user = User.find(like.user_id)
        the_item = Item.find(like.likeable_id)

        if !the_user.liked_items.include? the_item
          puts "liking #{the_item.id}"
          the_like = RecordedLike.new({item: the_item, source: :import, recorded_date: like.created_at})
          the_user.recorded_likes << the_like
          the_like.save
          the_user.save
        end
      rescue
        puts "error"
      end
    end
  end
end
