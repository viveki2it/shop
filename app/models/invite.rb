class Invite < ActiveRecord::Base
  has_many :users
  belongs_to :landing_page_variant
  has_many :signups
  has_many :interactions, :as => :target

  def to_s
    self.code
  end
end
