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
      fail_document(document, document_id, "CV analysis timed out. Please try again.")
    rescue Anthropic::Errors::AuthenticationError
      fail_document(document, document_id, "Invalid Anthropic API key. Please re-upload with a valid key.")
    rescue Anthropic::Errors::RateLimitError
      fail_document(document, document_id, "Anthropic rate limit reached. Please wait a moment and try again.")
    rescue Anthropic::Errors::APIStatusError => e
      fail_document(document, document_id, "Anthropic API error (#{e.status_code}): #{e.message}")
    rescue => e
      fail_document(document, document_id, e.message)
    end
  end

  private

  def fail_document(document, document_id, message)
    Rails.logger.error("CV parsing failed for document #{document_id}: #{message}")
    document.update_columns(
      parsing_status: CandidateDocument.parsing_statuses[:failed],
      parse_error: message
    )
  end
end
