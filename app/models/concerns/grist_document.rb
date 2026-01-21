# frozen_string_literal: true

require "blanket"

class GristDocument
  attr_reader :doc_id

  delegate :tables, to: :wrapper

  def initialize(doc_id)
    @doc_id = doc_id
  end

  def table_exist?(name)
    table_names.include?(name)
  end

  def table_names
    tables
      .get
      .payload["tables"]
      .map(&:id)
  end

  def create_table_schema!(table_schema)
    tables
      .post(
        body: {
          tables: [table_schema]
        }.to_json
      )
  end

  def wrapper
    api.docs(@doc_id)
  end

  private

  def api
    @api ||= wrap_api
  end

  def wrap_api
    Blanket
      .wrap(
        ENV.fetch("GRIST_API_URL"),
        headers: {
          "Authorization" => "Bearer #{ENV.fetch('GRIST_API_TOKEN')}",
          "Content-Type" => "application/json"
        }
      )
  end
end
