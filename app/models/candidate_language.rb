class CandidateLanguage < ApplicationRecord
  belongs_to :candidate_profile
  belongs_to :language

  LEVELS = %w[a1 a2 b1 b2 c1 c2 native].freeze

  validates :language_id, uniqueness: { scope: :candidate_profile_id }
  validates :level, inclusion: { in: LEVELS }, allow_blank: true
end
