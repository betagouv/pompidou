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
        .includes(:latest_phase, :incubator)
        .limit(3)
        .map { |startup| startup_upsert_payload(startup) }
    end

    def startup_upsert_payload(startup)
      {
        require: {
          identifiant: startup.ghid
        },
        fields: {
          budget_url: startup.budget_url,
          contact_email: startup.contact,
          current_phase: startup.latest_phase.name,
          current_phase_started_on: startup.latest_phase.start,
          dashlord_url: startup.dashlord_url,
          impact_url: startup.impact_url,
          incubator: startup.incubator.title,
          incubator_contact: startup.incubator.contact,
          link: startup.link,
          mission: startup.pitch,
          name: startup.name,
        }
      }
    end
  end
end
