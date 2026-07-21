class Skill < ApplicationRecord
  belongs_to :job_function
  has_many :candidate_skills, dependent: :destroy
  has_many :candidate_profiles, through: :candidate_skills

  validates :name, presence: true
end
