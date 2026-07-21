class OnboardingCompletedNotificationJob < ApplicationJob
  queue_as :default

  def perform(profile_id)
    profile = CandidateProfile.includes(:user).find_by(id: profile_id)
    return unless profile

    Rails.logger.info "candidate_onboarding_completed: profile_id=#{profile_id}, user=#{profile.user.email_address}"
    # Future: send email notification, trigger webhook, etc.
  end
end
