require 'rails_helper'

RSpec.describe CandidateProfile, "#assign_parsed_attributes" do
  let(:user)    { create(:user) }
  let(:profile) { create(:candidate_profile, user: user) }

  before do
    @dental_hygienist = JobFunction.find_or_create_by!(slug: "dental_hygienist") do |jf|
      jf.name = "Dental hygienist"; jf.position = 2
    end
    Language.find_or_create_by!(code: "nl") { |l| l.name = "Dutch" }
    Skill.find_or_create_by!(name: "Periodontology", job_function: @dental_hygienist)
  end

  let(:parsed) do
    {
      "first_name"    => "Jan",
      "last_name"     => "de Vries",
      "email"         => "jan@example.com",
      "city"          => "Amsterdam",
      "country"       => "Netherlands",
      "job_function"  => "Dental hygienist",
      "languages"     => [ { "name" => "Dutch", "level" => "native" } ],
      "educations"    => [ { "study_course" => "Dental Hygiene", "level" => "hbo", "start_date" => "2015-09-01", "end_date" => "2019-06-30" } ],
      "work_experiences" => [ { "job_title" => "Hygienist", "company_name" => "Clinic X", "current_job" => true } ],
      "skills"        => [ "Periodontology" ],
      "uncertain_fields" => []
    }
  end

  it "assigns scalar fields" do
    profile.assign_parsed_attributes(parsed)
    expect(profile.first_name).to eq("Jan")
    expect(profile.email).to eq("jan@example.com")
    expect(profile.city).to eq("Amsterdam")
  end

  it "assigns job function" do
    profile.assign_parsed_attributes(parsed)
    expect(profile.job_function).to eq(@dental_hygienist)
  end

  it "builds educations" do
    profile.assign_parsed_attributes(parsed)
    expect(profile.educations.length).to eq(1)
    expect(profile.educations.first.study_course).to eq("Dental Hygiene")
  end

  it "builds work experiences" do
    profile.assign_parsed_attributes(parsed)
    expect(profile.work_experiences.length).to eq(1)
    expect(profile.work_experiences.first.current_job).to be true
  end

  it "assigns languages" do
    profile.assign_parsed_attributes(parsed)
    expect(profile.candidate_languages.length).to eq(1)
    expect(profile.candidate_languages.first.level).to eq("native")
  end

  it "assigns skills" do
    profile.assign_parsed_attributes(parsed)
    expect(profile.candidate_skills.length).to eq(1)
  end
end
