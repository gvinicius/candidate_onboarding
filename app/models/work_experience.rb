class WorkExperience < ApplicationRecord
  belongs_to :candidate_profile

  validates :job_title, presence: true
  validates :company_name, presence: true

  default_scope { order(Arel.sql("current_job DESC, COALESCE(end_date, 'infinity'::date) DESC, start_date DESC")) }
end
