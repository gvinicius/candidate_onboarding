class CandidateProfile < ApplicationRecord
  belongs_to :user
  belongs_to :job_function, optional: true
  has_many :candidate_documents, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :work_experiences, dependent: :destroy
  has_many :candidate_skills, dependent: :destroy
  has_many :skills, through: :candidate_skills
  has_many :candidate_languages, dependent: :destroy
  has_many :languages, through: :candidate_languages
  has_many :candidate_regions, dependent: :destroy
  has_many :regions, through: :candidate_regions

  enum :search_status, { active: 0, passive: 1, inactive: 2 }
  enum :big_registration_status, {
    big_registered: 0,
    in_progress: 1,
    under_supervision: 2,
    not_applicable: 3
  }

  TRANSPORT_OPTIONS = %w[bike scooter public_transport car].freeze
  EMPLOYMENT_TYPES  = %w[employed self_employed freelance percentage_based].freeze
  WORKING_DAYS      = %w[monday tuesday wednesday thursday friday saturday sunday].freeze

  validates :first_name, presence: true, on: :complete
  validates :last_name, presence: true, on: :complete
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, on: :complete
  validates :city, presence: true, on: :complete
  validates :job_function, presence: true, on: :complete
  validates :max_travel_time, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :years_of_experience, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :desired_gross_salary, numericality: { greater_than: 0 }, allow_nil: true
  validates :desired_percentage, numericality: { in: 0..100 }, allow_nil: true
  validates :average_daily_revenue, numericality: { greater_than: 0 }, allow_nil: true
  validates :consent_given, acceptance: true, on: :complete

  def requires_big?
    job_function&.requires_big?
  end

  def employed?
    desired_employment_types.include?("employed")
  end

  def self_employed?
    (desired_employment_types & %w[self_employed freelance percentage_based]).any?
  end
end
