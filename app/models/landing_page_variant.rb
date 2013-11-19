class LandingPageVariant < ActiveRecord::Base
  attr_accessible :internal_title, :internal_description, :box1, :box2, :box3, :description, :download_button_text, :heading1, :heading2, :hero_image, :invite_id, :landing_page_layout_id, :show_supported_shops, :show_trending, :hero_image_cache,:remove_hero_image, :show_three_boxes, :chrome_inline_install

  has_many :invites
  belongs_to :landing_page_layout

  mount_uploader :hero_image, LandingPageHeroUploader

  def to_s
    self.internal_title
  end
end
