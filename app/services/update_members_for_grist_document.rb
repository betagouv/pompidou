# frozen_string_literal: true

require "yaml"

class UpdateMembersForGristDocument
  MEMBERS_SCHEMA =
    YAML
    .load_file(Rails.root.join("config/grist_schemas.yml"))
    .dig("grist", "schemas", "tables", "members")

  MEMBERS_TABLE_ID = MEMBERS_SCHEMA["id"]

  class << self
    def call(document_id)
      UpdateGristDocument.call(
        document_id: document_id,
        schema: MEMBERS_SCHEMA,
        table_id: MEMBERS_SCHEMA["id"],
        records: all_members_payload
      )
    end

    def all_members_payload
      EspaceMembre::User
        .all
        .map { |user| user_upsert_payload(user) }
    end

    def user_upsert_payload(user)
      {
        require: {
          identifiant: user.username
        },
        fields: {
          name: user.fullname,
          gender: user.gender,
          email: user.primary_email,
          secondary_email: user.secondary_email,
          domain: user.domaine,
          active_mission: user.has_active_mission?
        }
      }
    end
  end
end
