class UpdateMembersForGristDocumentJob < ApplicationJob
  queue_as :default

  def perform(document_id)
    UpdateMembersForGristDocument.call(document_id)
  end
end
