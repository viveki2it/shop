#sets up kiss metrics and provides support for anonymous users

module Km
	def generate_identifier
	  now = Time.now.to_i  
	  Digest::MD5.hexdigest(
	    (request.referrer || '') + 
	    rand(now).to_s + 
	    now.to_s + 
	    (request.user_agent || '')
	  )
	end

	def km_init
	  KM.init('786b8daf5efbd1581a637fe7a99c828e70fff720',:env=>'production')
	  if not identity = cookies[:km_identity]
	    identity = generate_identifier
	    cookies[:km_identity] = {
	      :value => identity, :expires => 5.years.from_now
	    }
	  end

	  # This example assumes you have a current_user, with a
	  # property "email". Use whatever makes sense for your
	  # app.
	  
	  if @the_user
	    if not cookies[:km_aliased]
	      KM.alias(identity, @the_user.identifier)
	      cookies[:km_aliased] = {
	        :value => true,
	        :expires => 5.years.from_now
	      }
	    end
	    identity = @the_user.identifier
	  end
	  KM.identify(identity)
	end
end