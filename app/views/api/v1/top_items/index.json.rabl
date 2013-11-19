object @top_items
attributes :id, :title, :image_path, :gender, :all_master_categories, :the_price, :url, :the_retailer, :affiliate_link
child :master_categories do 
	attributes :id, :name, :male_only_name
end
