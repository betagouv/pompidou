require "rails_helper"

RSpec.describe UpdateServicesForGristDocumentJob, type: :job do
  before do
    allow(UpdateServicesForGristDocument).to receive(:call)
  end

  it "forwards to the service" do
    described_class.perform_now("foo")

    expect(UpdateServicesForGristDocument).to have_received(:call).with("foo")
  end
end
