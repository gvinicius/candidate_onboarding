FactoryBot.define do
  factory :work_experience do
    candidate_profile
    job_title    { Faker::Job.title }
    company_name { Faker::Company.name }
    responsibilities { Faker::Lorem.paragraph }
    start_date   { Faker::Date.between(from: 5.years.ago, to: 2.years.ago) }
    end_date     { Faker::Date.between(from: 1.year.ago, to: Date.today) }
    current_job  { false }
  end
end
