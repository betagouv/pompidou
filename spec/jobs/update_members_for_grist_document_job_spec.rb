require "rails_helper"

RSpec.describe UpdateMembersForGristDocumentJob, type: :job do
  before do
    allow(UpdateMembersForGristDocument).to receive(:call)
  end

  it "forwards to the service" do
    described_class.perform_now("foo")

    expect(UpdateMembersForGristDocument).to have_received(:call).with("foo")
  end
end
