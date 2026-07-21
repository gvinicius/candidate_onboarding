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

  def assign_parsed_attributes(parsed)
    return unless parsed.is_a?(Hash)

    scalar_fields = %i[first_name last_name email phone_number city country
                       years_of_experience big_number professional_summary]
    scalar_fields.each do |field|
      value = parsed[field.to_s]
      assign_attributes(field => value) if value.present?
    end

    if parsed["job_function"].present?
      jf = JobFunction.find_by("name ILIKE ?", parsed["job_function"])
      self.job_function = jf if jf
    end

    assign_parsed_educations(parsed["educations"])
    assign_parsed_work_experiences(parsed["work_experiences"])
    assign_parsed_languages(parsed["languages"])
    assign_parsed_skills(parsed["skills"])
  end

  private

  def assign_parsed_educations(list)
    return unless list.is_a?(Array)
    list.each do |edu|
      next unless edu["study_course"].present?
      educations.build(
        institution:  edu["institution"],
        study_course: edu["study_course"],
        city_country: edu["city_country"],
        level:        safe_enum(:level, Education, edu["level"]),
        start_date:   parse_date(edu["start_date"]),
        end_date:     parse_date(edu["end_date"])
      )
    end
  end

  def assign_parsed_work_experiences(list)
    return unless list.is_a?(Array)
    list.each do |exp|
      next unless exp["job_title"].present? && exp["company_name"].present?
      work_experiences.build(
        job_title:       exp["job_title"],
        company_name:    exp["company_name"],
        responsibilities: exp["responsibilities"],
        start_date:      parse_date(exp["start_date"]),
        end_date:        parse_date(exp["end_date"]),
        current_job:     exp["current_job"] || false
      )
    end
  end

  def assign_parsed_languages(list)
    return unless list.is_a?(Array)
    list.each do |lang|
      next unless lang["name"].present?
      language = Language.find_by("name ILIKE ?", lang["name"])
      next unless language
      level = lang["level"]&.downcase
      level = nil unless CandidateLanguage::LEVELS.include?(level)
      candidate_languages.build(language: language, level: level)
    end
  end

  def assign_parsed_skills(list)
    return unless list.is_a?(Array)
    jf_scope = job_function ? Skill.where(job_function: job_function) : Skill.all
    list.each do |name|
      skill = jf_scope.find_by("name ILIKE ?", name)
      candidate_skills.build(skill: skill) if skill
    end
  end

  def parse_date(str)
    return nil if str.blank?
    Date.parse(str)
  rescue ArgumentError
    nil
  end

  def safe_enum(field, klass, value)
    return nil if value.blank?
    klass.public_send(field.to_s.pluralize).key?(value) ? value : nil
  end
end
