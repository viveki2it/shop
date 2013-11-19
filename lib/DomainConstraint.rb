class DomainConstraint 
	def initialize(domains)
		@domains = domains
	end

	def matches?(request)
		if @domains.include? request.subdomain
			true
		else
			false
		end
	end
end
