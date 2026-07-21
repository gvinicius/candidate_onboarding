require 'rails_helper'

RSpec.describe Education, type: :model do
  it { is_expected.to belong_to(:candidate_profile) }
  it { is_expected.to validate_presence_of(:study_course) }
  it { is_expected.to define_enum_for(:level).with_values(mbo: 0, hbo: 1, bachelor: 2, master: 3, doctor: 4, course: 5) }

  describe "factory" do
    it "creates a valid record" do
      expect(build(:education)).to be_valid
    end
  end
end
