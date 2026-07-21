class CandidateDocument < ApplicationRecord
  belongs_to :candidate_profile
  has_one_attached :file

  enum :document_type, { cv: 0 }
  enum :parsing_status, { pending: 0, processing: 1, completed: 2, failed: 3 }

  ACCEPTED_CONTENT_TYPES = %w[
    application/pdf
    application/msword
    application/vnd.openxmlformats-officedocument.wordprocessingml.document
  ].freeze

  MAX_FILE_SIZE = ENV.fetch("MAX_CV_SIZE_MB", 25).to_i.megabytes

  validate :file_must_be_attached
  validate :acceptable_file

  private

  def file_must_be_attached
    errors.add(:file, "must be attached") unless file.attached?
  end

  def acceptable_file
    return unless file.attached?

    unless ACCEPTED_CONTENT_TYPES.include?(file.content_type)
      errors.add(:file, "must be a PDF, DOC, or DOCX file")
    end

    if file.byte_size > MAX_FILE_SIZE
      errors.add(:file, "is too large (max #{ENV.fetch("MAX_CV_SIZE_MB", 25)} MB)")
    end
  end
end
