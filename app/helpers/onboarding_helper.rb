module OnboardingHelper
  # Returns a badge if the field was extracted from CV or is empty
  def field_badge(profile, field)
    document = profile.candidate_documents.order(:created_at).last
    return unless document&.completed?

    value = profile.public_send(field)
    if value.blank?
      content_tag(:span, "Missing", class: "badge-missing ml-1")
    elsif document.raw_text.present?
      content_tag(:span, "Extracted from CV", class: "badge-extracted ml-1")
    end
  end
end
