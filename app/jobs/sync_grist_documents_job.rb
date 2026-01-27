class SyncGristDocumentsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    jobs = ENV.fetch("GRIST_SYNC_DOCUMENT_IDS")
              .split(",")
              .flat_map do |doc_id|
                [
                  UpdateServicesForGristDocumentJob.new(doc_id),
                  UpdateMembersForGristDocumentJob.new(doc_id)
                ]
              end

    ActiveJob.perform_all_later(jobs)
  end
end
