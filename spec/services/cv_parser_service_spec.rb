require 'rails_helper'

RSpec.describe CvParserService do
  let(:user)     { create(:user) }
  let(:profile)  { create(:candidate_profile, user: user) }
  let(:document) { create(:candidate_document, candidate_profile: profile) }

  let(:parsed_result) do
    {
      "first_name" => "Jan",
      "last_name"  => "de Vries",
      "email"      => "jan@example.com",
      "phone_number" => "+31612345678",
      "city"       => "Amsterdam",
      "country"    => "Netherlands",
      "languages"  => [{ "name" => "Dutch", "level" => "native" }],
      "job_function" => "Dental hygienist",
      "years_of_experience" => 5,
      "big_number" => nil,
      "professional_summary" => "Experienced dental hygienist.",
      "educations" => [
        {
          "institution" => "HBO Mondhygiëne",
          "study_course" => "Dental Hygiene",
          "city_country" => "Utrecht, Netherlands",
          "level" => "hbo",
          "start_date" => "2015-09-01",
          "end_date" => "2019-06-30"
        }
      ],
      "work_experiences" => [
        {
          "job_title" => "Dental Hygienist",
          "company_name" => "Tandartspraktijk De Laan",
          "responsibilities" => "Cleaning, patient education",
          "start_date" => "2019-08-01",
          "end_date" => nil,
          "current_job" => true
        }
      ],
      "skills" => ["Periodontology", "Prevention"],
      "uncertain_fields" => []
    }
  end

  describe "#call" do
    before do
      allow_any_instance_of(CvTextExtractor).to receive(:extract).and_return("Sample CV text")
      allow_any_instance_of(CvParserService).to receive(:parse_with_claude).and_return(parsed_result)
    end

    it "returns a parsed hash" do
      service = CvParserService.new(document)
      result = service.call
      expect(result).to be_a(Hash)
      expect(result["first_name"]).to eq("Jan")
    end
  end
end
