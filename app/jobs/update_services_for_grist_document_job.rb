class UpdateServicesForGristDocumentJob < ApplicationJob
  queue_as :default

  def perform(document_id)
    UpdateServicesForGristDocument.call(document_id)
  end
end
