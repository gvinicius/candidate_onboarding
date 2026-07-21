class JobFunction < ApplicationRecord
  has_many :skills, dependent: :destroy
  has_many :candidate_profiles, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  # Functions that require BIG registration
  BIG_REQUIRED_SLUGS = %w[general_dentist dental_hygienist specialist].freeze

  def requires_big?
    BIG_REQUIRED_SLUGS.include?(slug)
  end
end
