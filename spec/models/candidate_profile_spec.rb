require 'rails_helper'

RSpec.describe CandidateProfile, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:job_function).optional }
  it { is_expected.to have_many(:candidate_documents).dependent(:destroy) }
  it { is_expected.to have_many(:educations).dependent(:destroy) }
  it { is_expected.to have_many(:work_experiences).dependent(:destroy) }
  it { is_expected.to have_many(:candidate_skills).dependent(:destroy) }
  it { is_expected.to have_many(:skills).through(:candidate_skills) }
  it { is_expected.to have_many(:candidate_languages).dependent(:destroy) }
  it { is_expected.to have_many(:languages).through(:candidate_languages) }
  it { is_expected.to have_many(:candidate_regions).dependent(:destroy) }
  it { is_expected.to have_many(:regions).through(:candidate_regions) }

  it { is_expected.to define_enum_for(:search_status).with_values(active: 0, passive: 1, inactive: 2) }

  describe "#requires_big?" do
    it "returns true for dentist job function" do
      jf      = build(:job_function, slug: "general_dentist")
      profile = build(:candidate_profile, job_function: jf)
      expect(profile.requires_big?).to be true
    end

    it "returns false for dental assistant" do
      jf      = build(:job_function, slug: "dental_assistant")
      profile = build(:candidate_profile, job_function: jf)
      expect(profile.requires_big?).to be false
    end
  end

  describe "#employed?" do
    it "returns true when desired_employment_types includes employed" do
      profile = build(:candidate_profile, desired_employment_types: [ "employed" ])
      expect(profile.employed?).to be true
    end

    it "returns false when only self-employed" do
      profile = build(:candidate_profile, desired_employment_types: [ "self_employed" ])
      expect(profile.employed?).to be false
    end
  end
end
