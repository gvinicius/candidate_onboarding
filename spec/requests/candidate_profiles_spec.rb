require "rails_helper"

RSpec.describe "CandidateProfiles", type: :request do
  describe "GET /candidate_profiles" do
    it "returns http success" do
      get candidate_profiles_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /candidate_profiles/:id" do
    it "returns http success" do
      profile = create(:candidate_profile)
      get candidate_profile_path(profile)
      expect(response).to have_http_status(:success)
    end
  end
end
