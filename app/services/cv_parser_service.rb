class CvParserService
  JOB_FUNCTIONS = [
    "General dentist", "Dental hygienist", "Dental assistant",
    "Prevention assistant", "Paro-prevention assistant", "Orthodontic assistant",
    "Front-office / receptionist", "Practice manager", "Dental technician", "Specialist"
  ].freeze

  PROMPT = <<~PROMPT.freeze
    You are a CV parser for a dental recruitment platform. Extract structured information from the CV text below.

    Return a valid JSON object with these exact keys (use null for missing fields — never invent data):
    {
      "first_name": string | null,
      "last_name": string | null,
      "email": string | null,
      "phone_number": string | null,
      "city": string | null,
      "country": string | null,
      "languages": [{"name": string, "level": string | null}],
      "job_function": string | null,
      "years_of_experience": number | null,
      "big_number": string | null,
      "professional_summary": string | null,
      "educations": [
        {
          "institution": string | null,
          "study_course": string,
          "city_country": string | null,
          "level": "mbo"|"hbo"|"bachelor"|"master"|"doctor"|"course"|null,
          "start_date": "YYYY-MM-DD"|null,
          "end_date": "YYYY-MM-DD"|null
        }
      ],
      "work_experiences": [
        {
          "job_title": string,
          "company_name": string,
          "responsibilities": string | null,
          "start_date": "YYYY-MM-DD"|null,
          "end_date": "YYYY-MM-DD"|null,
          "current_job": boolean
        }
      ],
      "skills": [string],
      "uncertain_fields": [string]
    }

    For job_function, map to one of these exact values (or null if unclear):
    #{JOB_FUNCTIONS.map { |f| "- #{f}" }.join("\n")}

    For language levels use: a1, a2, b1, b2, c1, c2, or native.
    For education levels: mbo (MBO/vocational), hbo (HBO/applied sciences), bachelor, master, doctor, course.
    Mark fields in uncertain_fields array if data was inferred rather than clearly stated.
    Return ONLY the JSON object, no other text.
  PROMPT

  def initialize(document, api_key: nil)
    @document = document
    @api_key  = api_key.presence || ENV["ANTHROPIC_API_KEY"]
  end

  def call
    raise "ANTHROPIC_API_KEY is not configured" unless @api_key.present?

    text = @document.raw_text.presence || begin
      extracted = CvTextExtractor.call(@document)
      @document.update_column(:raw_text, extracted.truncate(50_000))
      extracted
    end
    parse_with_claude(text)
  end

  private

  def parse_with_claude(text)
    client   = Anthropic::Client.new(api_key: @api_key)
    response = Timeout.timeout(100) do
      client.messages.create(
        model: "claude-haiku-4-5-20251001",
        max_tokens: 2048,
        messages: [
          {
            role: "user",
            content: "#{PROMPT}\n\n---CV TEXT---\n#{text.truncate(30_000)}"
          }
        ]
      )
    end

    raw_json = response.content.first.text.strip
    JSON.parse(raw_json)
  rescue JSON::ParserError => e
    raise "CV parser returned invalid JSON: #{e.message}"
  end
end
