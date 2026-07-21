require 'rails_helper'

RSpec.describe JobFunction, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:slug) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_uniqueness_of(:slug) }
  it { is_expected.to have_many(:skills).dependent(:destroy) }

  describe "#requires_big?" do
    it "returns true for general_dentist" do
      jf = build(:job_function, slug: "general_dentist")
      expect(jf.requires_big?).to be true
    end

    it "returns false for dental_assistant" do
      jf = build(:job_function, slug: "dental_assistant")
      expect(jf.requires_big?).to be false
    end
  end
end
