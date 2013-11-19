class Analytics::RealInstallsController < ApplicationController
  layout 'analytics'
  before_filter :authenticate_admin_user!

  def index
    #@real_installs = User.where('last_started_extension > ? OR last_active > ?', Date.today - 30.days, Date.today - 30.days).all.sort { |a,b| b.visits.where('created_at > ?', Date.today - 30.days).count - a.visits.where('created_at > ?',Date.today - 30.days).count}
    @real_installs = User.where('last_started_extension > ? OR last_active > ?', Date.today - 30.days, Date.today - 30.days).order('created_at desc')
  end
end
