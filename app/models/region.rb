class Region < ApplicationRecord
  has_many :candidate_regions, dependent: :destroy
  has_many :candidate_profiles, through: :candidate_regions

  validates :name, presence: true, uniqueness: true
end
