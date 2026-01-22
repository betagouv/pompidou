# frozen_string_literal: true

require "blanket"

class UpdateGristDocument
  class << self
    def call(document_id:, schema:, table_id:, records:)
      document = GristDocument.new(document_id)

      document.create_table_schema!(schema) unless document.table_exist?(table_id)

      # debugger

      document
        .tables(table_id)
        .records
        .put(
          body: {
            records: records
          }.to_json
        )
    end
  end
end
