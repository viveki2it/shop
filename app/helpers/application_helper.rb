module ApplicationHelper
	def get_user_score (user)
		if user.score.nil? 
			user.score = 0
			user.save
		end
		u = user.score
		if u > 1920
			10
		elsif u > 960
			9
		elsif u > 480
			8
		elsif u > 240
			7
		elsif u > 120
			6
		elsif u > 60
			5
		elsif u > 30
			4
		elsif u > 15
			3
		elsif u > 5
			2
		elsif u > 0
			1
		else
			0
		end
	end
end
