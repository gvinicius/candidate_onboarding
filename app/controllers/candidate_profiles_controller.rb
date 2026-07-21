class CandidateProfilesController < ApplicationController
  skip_before_action :require_authentication

  def index
    scope = CandidateProfile
              .includes(:job_function, :candidate_documents, :user)
              .order(created_at: :desc)

    if params[:q].present?
      q = "%#{params[:q].strip}%"
      scope = scope.where(
        "first_name ILIKE :q OR last_name ILIKE :q OR email ILIKE :q OR city ILIKE :q",
        q: q
      )
    end

    @pagy, @profiles = pagy(scope)
  end

  def show
    @profile = CandidateProfile.includes(
      :job_function, :educations, :work_experiences,
      :skills, :languages, :regions, :candidate_documents
    ).find(params[:id])
  end
end
