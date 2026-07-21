FactoryBot.define do
  factory :candidate_document do
    candidate_profile { nil }
    document_type { 1 }
    original_filename { "MyString" }
    content_type { "MyString" }
    file_size { 1 }
    parsing_status { 1 }
    parsed_at { "2026-07-21 10:48:20" }
    parse_error { "MyText" }
    raw_text { "MyText" }
  end
end
