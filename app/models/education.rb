class Education < ApplicationRecord
  belongs_to :candidate_profile

  enum :level, { mbo: 0, hbo: 1, bachelor: 2, master: 3, doctor: 4, course: 5 }

  validates :study_course, presence: true
  validates :level, inclusion: { in: levels.keys }, allow_nil: true

  default_scope { order(:position, :start_date) }
end
