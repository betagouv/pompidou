# frozen_string_literal: true

require "rails_helper"

RSpec.describe UpdateServicesIntoGristDocumentsJob do
  before do
    allow(ENV).to receive(:fetch).with("GRIST_DOCUMENT_IDS").and_return("foo,bar")
  end

  it "enqueues a job for each value in the comma-separated document ids variable" do
    expect { described_class.perform_now }
      .to have_enqueued_job(UpdateServicesForGristDocumentJob)
      .exactly(:twice)
  end
end
