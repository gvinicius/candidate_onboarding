class SummaryGeneratorService
  def self.call(profile, api_key: nil)
    new(profile, api_key: api_key).call
  end

  def initialize(profile, api_key: nil)
    @profile = profile
    @api_key = api_key.presence || ENV["ANTHROPIC_API_KEY"]
  end

  def call
    if Rails.env.test? && ENV["STUB_CV_PARSER"].present?
      return "Test candidate with 3 years of experience as a dental hygienist based in Amsterdam."
    end

    raise "ANTHROPIC_API_KEY is not configured" unless @api_key.present?

    client = Anthropic::Client.new(api_key: @api_key)
    response = Timeout.timeout(30) do
      client.messages.create(
        model: "claude-haiku-4-5-20251001",
        max_tokens: 300,
        messages: [ { role: "user", content: prompt } ]
      )
    end
    response.content.first.text.strip
  end

  private

  def prompt
    p = @profile
    lines = []
    lines << "Name: #{[ p.first_name, p.last_name ].compact.join(' ')}" if p.first_name.present?
    lines << "Job function: #{p.job_function&.name}" if p.job_function.present?
    lines << "Years of experience: #{p.years_of_experience}" if p.years_of_experience.present?
    lines << "City: #{p.city}" if p.city.present?

    if p.work_experiences.any?
      lines << "Work experience:"
      p.work_experiences.each do |w|
        lines << "  - #{w.job_title} at #{w.company_name}"
      end
    end

    if p.educations.any?
      lines << "Education:"
      p.educations.each do |e|
        lines << "  - #{e.study_course} at #{e.institution}" if e.study_course.present?
      end
    end

    lines << "Skills: #{p.skills.map(&:name).join(', ')}" if p.skills.any?

    <<~PROMPT
      Write a concise 2-3 sentence professional summary for a dental professional candidate based on the following profile data.
      Write in the third person. Be factual and professional. Do not invent details not present in the data.

      #{lines.join("\n")}

      Return only the summary text, no labels or headers.
    PROMPT
  end
end
