FactoryBot.define do
  factory :job_function do
    sequence(:name) { |n| "#{Faker::Job.title} #{n}" }
    sequence(:slug) { |n| "job_function_#{n}" }
    sequence(:position) { |n| n }
  end
end
