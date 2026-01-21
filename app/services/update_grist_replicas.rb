# frozen_string_literal: true

require "yaml"
require "blanket"

class UpdateGristReplicas
  SERVICES_SCHEMA =
    YAML
    .load_file(Rails.root.join("config/grist_schemas.yml"))
    .dig("grist", "schemas", "tables", "services")

  class << self
    def call
      ENV.fetch("GRIST_DOCUMENT_IDS")
         .split(",")
         .each { |id| process_document!(id) }
    end

    private

    def process_document!(id)
      document = GristDocument.new(id)

      document.create_table_schema!(SERVICES_SCHEMA) unless document.table_exist?("Services_numeriques")

      document
        .tables("Services_numeriques")
        .records
        .put(
          body: {
            records: all_startups_payload
          }.to_json
        )
    end

    def all_startups_payload
      EspaceMembre::Startup
        .includes(:latest_phase)
        .in_phase(:construction, :acceleration, :transfer) # FIXME: a scope maybe
        .map { |startup| startup_upsert_payload(startup) }
    end

    def startup_upsert_payload(startup)
      {
        require: {
          identifiant: startup.ghid
        },
        fields: {
          name: startup.name,
          impact_url: startup.impact_url,
          current_phase: startup.latest_phase.name,
          contact_email: startup.contact,
          mission: startup.pitch,
          link: startup.link
        }
      }
    end
  end
end
