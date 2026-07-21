FactoryBot.define do
  factory :education do
    candidate_profile
    institution  { Faker::University.name }
    study_course { Faker::Educator.course_name }
    city_country { "#{Faker::Address.city}, #{Faker::Address.country}" }
    level        { :bachelor }
    start_date   { Faker::Date.between(from: 10.years.ago, to: 5.years.ago) }
    end_date     { Faker::Date.between(from: 4.years.ago, to: 1.year.ago) }
  end
end
