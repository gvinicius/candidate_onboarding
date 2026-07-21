FactoryBot.define do
  factory :candidate_document do
    candidate_profile
    document_type    { :cv }
    original_filename { "resume.pdf" }
    content_type     { "application/pdf" }
    file_size        { 1024 }
    parsing_status   { :pending }

    after(:build) do |doc|
      doc.file.attach(
        io: StringIO.new("%PDF-1.4 sample content"),
        filename: "resume.pdf",
        content_type: "application/pdf"
      )
    end
  end
end
