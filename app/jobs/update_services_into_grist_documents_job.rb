class UpdateServicesIntoGristDocumentsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    jobs = ENV.fetch("GRIST_DOCUMENT_IDS")
              .split(",")
              .map { |id| UpdateServicesForGristDocumentJob.new(id) }

    ActiveJob.perform_all_later(jobs)
  end
end
