require 'rails_helper'

RSpec.describe "Onboarding", type: :request do
  describe "GET /" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /onboarding/upload" do
    context "with a valid PDF file" do
      let(:pdf_file) do
        fixture_file_upload(Rails.root.join("spec/fixtures/files/sample.pdf"), "application/pdf")
      end

      it "redirects to status page and enqueues job" do
        expect {
          post onboarding_upload_path, params: { file: pdf_file }
        }.to have_enqueued_job(ParseCandidateCvJob)
        expect(response).to redirect_to(onboarding_status_path)
      end
    end

    context "with an invalid file type" do
      let(:txt_file) do
        fixture_file_upload(Rails.root.join("spec/fixtures/files/sample.txt"), "text/plain")
      end

      it "returns unprocessable entity" do
        post onboarding_upload_path, params: { file: txt_file }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "without a file" do
      it "returns unprocessable entity" do
        post onboarding_upload_path
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /onboarding/status.json" do
    it "returns processing status" do
      get onboarding_status_path(format: :json)
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["status"]).to eq("processing")
    end
  end
end
