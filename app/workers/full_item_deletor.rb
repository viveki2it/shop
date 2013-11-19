class FullItemDeletor
  include Sidekiq::Worker

  # delete the item including callbacks, need this in a background
  # task because the callbacks can take forever to run if there are
  # a lot of full item histories
  def perform(id)
    FullItem.find(id).destroy
  end
end
