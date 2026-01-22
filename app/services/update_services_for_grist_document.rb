# frozen_string_literal: true

require "yaml"

class UpdateServicesForGristDocument
  SERVICES_SCHEMA =
    YAML
    .load_file(Rails.root.join("config/grist_schemas.yml"))
    .dig("grist", "schemas", "tables", "services")

  SERVICES_TABLE_ID = SERVICES_SCHEMA["id"]

  class << self
    def call(document_id)
      UpdateGristDocument.call(
        document_id: document_id,
        schema: SERVICES_SCHEMA,
        table_id: SERVICES_SCHEMA["id"],
        records: all_startups_payload
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
