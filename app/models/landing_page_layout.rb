class LandingPageLayout < ActiveRecord::Base
  attr_accessible :partial, :title

  has_many :landing_page_variants
  has_many :invites
end
