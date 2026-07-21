class ParseCandidateCvJob < ApplicationJob
  queue_as :default

  def perform(document_id, api_key = nil)
    document = CandidateDocument.find_by(id: document_id)
    return unless document

    document.update!(parsing_status: :processing)

    begin
      parser  = CvParserService.new(document, api_key: api_key)
      result  = parser.call
      profile = document.candidate_profile

      ActiveRecord::Base.transaction do
        profile.assign_parsed_attributes(result)
        profile.save!
        document.update!(parsing_status: :completed, parsed_at: Time.current)
      end
    rescue => e
      Rails.logger.error("CV parsing failed for document #{document_id}: #{e.message}")
      document.update!(parsing_status: :failed, parse_error: e.message)
    end
  end
end
