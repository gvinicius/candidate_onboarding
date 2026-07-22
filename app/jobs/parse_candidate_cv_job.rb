class ParseCandidateCvJob < ApplicationJob
  queue_as :default
  self.log_arguments = false

  def perform(document_id, api_key = nil)
    document = CandidateDocument.find_by(id: document_id)
    return unless document

    document.update_columns(parsing_status: CandidateDocument.parsing_statuses[:processing])

    begin
      parser  = CvParserService.new(document, api_key: api_key)
      result  = parser.call
      profile = document.candidate_profile

      ActiveRecord::Base.transaction do
        profile.assign_parsed_attributes(result)
        profile.save!
        document.update_columns(parsing_status: CandidateDocument.parsing_statuses[:completed], parsed_at: Time.current)
      end
    rescue Timeout::Error
      Rails.logger.error("CV parsing timed out for document #{document_id}")
      document.update_columns(parsing_status: CandidateDocument.parsing_statuses[:failed], parse_error: "CV analysis timed out. Please try again.")
    rescue => e
      Rails.logger.error("CV parsing failed for document #{document_id}: #{e.message}")
      document.update_columns(parsing_status: CandidateDocument.parsing_statuses[:failed], parse_error: e.message)
    end
  end
end
