# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncGristDocumentsJob do
  before do
    allow(ENV).to receive(:fetch).with("GRIST_SYNC_DOCUMENT_IDS").and_return("foo,bar")
  end

  describe "for each value in the comma-separated env" do
    it "enqueues the services sync job" do
      expect { described_class.perform_now }
        .to have_enqueued_job(UpdateServicesForGristDocumentJob)
        .exactly(:twice)
    end

    it "enqueues the members sync job" do
      expect { described_class.perform_now }
        .to have_enqueued_job(UpdateMembersForGristDocumentJob)
        .exactly(:twice)
    end
  end
end
