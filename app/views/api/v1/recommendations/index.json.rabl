object @recommendations
attributes :id, :title, :image_path, :gender, :all_master_categories, :the_retailer, :the_price, :url, :affiliate_link
child :master_categories do 
	attributes :id, :name, :male_only_name
end
