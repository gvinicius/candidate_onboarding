require 'rails_helper'

RSpec.describe "Onboarding Profile", type: :request do
  describe "GET /onboarding/profile" do
    it "creates a guest session and shows profile form" do
      get root_path
      get onboarding_profile_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /onboarding/skills" do
    let!(:jf) { create(:job_function, slug: "dental_hygienist", name: "Dental hygienist") }
    let!(:skill) { create(:skill, name: "Periodontology", job_function: jf) }

    it "returns skills for a job function" do
      get onboarding_skills_path(job_function_id: jf.id)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Periodontology")
    end

    it "returns empty response for unknown job function" do
      get onboarding_skills_path(job_function_id: 99999)
      expect(response).to have_http_status(:success)
    end
  end
end
