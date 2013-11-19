class Signup < ActiveRecord::Base
	validates_presence_of :email

  belongs_to :invite
end
