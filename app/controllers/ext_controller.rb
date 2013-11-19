class ExtController < ApplicationController
  include Km

  def show
    km_init
  	dl = Analytics::Downloads.new
  	if params[:update]
  		dl.track({:type=>'safari',:update=>params[:update]})
      KM.record('Update the Extension',{'browser_downloaded_for' => 'safari'})
    elsif params[:invite_code]
      dl.track({:type=>'safari',:invite_code=>params[:invite_code]})
      KM.set({:invite_code=>params[:invite_code]});
  	else
  		dl.track({:type=>'safari'})
  	end
  	send_file Rails.root.join('public', 'extension','sgv1.safariextz'), :type => "application/octet-stream"
  end

  def chrome
    km_init
  	dl = Analytics::Downloads.new
  	if params[:update]
  		dl.track({:type=>'chrome',:update=>params[:update]})
      KM.record('Update the Extension',{'browser_downloaded_for' => 'chrome'})
  	elsif params[:invite_code]
      dl.track({:type=>'chrome',:invite_code=>params[:invite_code]})
      KM.set({:invite_code=>params[:invite_code]});
    else
  		dl.track({:type=>'chrome'})
  	end
  	send_file Rails.root.join('public', 'chrome_extension','sgv1.crx'), :type => "application/x-chrome-extension"
  end
end
