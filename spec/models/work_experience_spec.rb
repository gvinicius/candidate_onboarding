require 'rails_helper'

RSpec.describe WorkExperience, type: :model do
  it { is_expected.to belong_to(:candidate_profile) }
  it { is_expected.to validate_presence_of(:job_title) }
  it { is_expected.to validate_presence_of(:company_name) }

  describe "factory" do
    it "creates a valid record" do
      expect(build(:work_experience)).to be_valid
    end
  end
end
