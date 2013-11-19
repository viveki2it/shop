module WebsiteHelper
	
	# provides the download link for the extension based on 
	# the contents of @agent
	def download_link(text)
		link_details = {:href => '', :class=> ''}
		if @agent
			link_details[:class] = @agent.name.to_s.downcase + '_download_link' + ' download_link'
			if @agent.name == :Chrome
				if @use_inline_chrome_download
					link_details[:href] = '#'
					link_details[:onclick] = 'chrome.webstore.install(\'https://chrome.google.com/webstore/detail/fdbndbhpboiobdllfphhljbfieaefmol\', somWebsite.chrome_inline_success, somWebsite.chrome_inline_failure);somWebsite.chrome_inline_init();return false;'
				else
					link_details[:href] = 'https://chrome.google.com/webstore/detail/fdbndbhpboiobdllfphhljbfieaefmol'
				end

			elsif @agent.name == :Safari
				link_details[:href] = '/safari'
			end
		end

		if link_details[:onclick]
			link_to text, link_details[:href], :class=> link_details[:class], onclick: link_details[:onclick]
			else
				link_to text, link_details[:href], :class=> link_details[:class], :target=>'_blank'
			end
	end
end
