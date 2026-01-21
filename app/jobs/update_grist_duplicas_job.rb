class UpdateGristDuplicasJob < ApplicationJob
  queue_as :default

  def perform(*args)
    UpdateGristReplicas.call
  end
end
