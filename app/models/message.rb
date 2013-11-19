class Message < ActiveRecord::Base
	validates_presence_of :name
	validates_presence_of :email
	validates_presence_of :content

	validates :name, :exclusion => {:in => %w(Name)}
	validates :email, :exclusion => {:in => %w(Email)}
	validates :content, :exclusion => {:in => %w(Message)}
end
