class Analytics::InvitesController < ApplicationController
  layout 'analytics'
  before_filter :authenticate_admin_user!

  def index
    @invites = Invite.all.sort {|a,b| b.users.count - a.users.count}
  end
end
