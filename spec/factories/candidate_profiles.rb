FactoryBot.define do
  factory :candidate_profile do
    user
    job_function

    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email      { Faker::Internet.unique.email }
    phone_number { Faker::PhoneNumber.phone_number }
    city       { Faker::Address.city }
    country    { Faker::Address.country }
    years_of_experience { rand(0..20) }
    search_status { :active }
    consent_given { true }
    consent_given_at { Time.current }
    desired_employment_types { ["employed"] }
    available_working_days { %w[monday tuesday wednesday thursday friday] }
    max_travel_time { 30 }
  end
end
