module RecommendationsHelper
	def image_link(item)
		if item.image_link
			if item.image_link.first == '/' && item.image_link[1]!= '/'
				unless item.supported_domain.nil?
					"http://" + item.supported_domain.domain + '/' + item.image_link
				else
					item.image_link
				end
			else
				item.image_link
			end
		end
	end

end
