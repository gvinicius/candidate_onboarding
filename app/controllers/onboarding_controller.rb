class OnboardingController < ApplicationController
  skip_before_action :require_authentication
  before_action :find_or_build_session_profile

  def index
  end

  def upload
    @document = CandidateDocument.new(candidate_profile: @profile)
    @document.file.attach(params[:file])
    @document.original_filename = params[:file]&.original_filename
    @document.content_type      = params[:file]&.content_type
    @document.file_size         = params[:file]&.size
    @document.document_type     = :cv
    @document.parsing_status    = :pending

    if @document.valid? && @profile.save && @document.save
      ParseCandidateCvJob.perform_later(@document.id)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("upload-section", partial: "onboarding/processing") }
        format.html { redirect_to onboarding_status_path }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("upload-errors", partial: "onboarding/errors", locals: { errors: @document.errors }) }
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  def status
    @document = @profile&.candidate_documents&.order(:created_at)&.last
    respond_to do |format|
      format.json do
        if @document&.completed?
          render json: { status: "completed", redirect_url: onboarding_profile_path }
        elsif @document&.failed?
          render json: { status: "failed" }
        else
          render json: { status: "processing" }
        end
      end
      format.html do
        if @document&.completed?
          redirect_to onboarding_profile_path
        elsif @document&.failed?
          @can_continue_manually = true
        end
      end
    end
  end

  def profile
    @profile = current_profile || redirect_to(onboarding_root_path) { return }
    @profile.educations.build if @profile.educations.empty?
    @profile.work_experiences.build if @profile.work_experiences.empty?
    load_form_data
  end

  def skills
    job_function = JobFunction.find_by(id: params[:job_function_id])
    @skills  = job_function ? job_function.skills.order(:name) : []
    @profile = current_profile || CandidateProfile.new
    render partial: "onboarding/skills_checkboxes", locals: { profile: @profile, skills: @skills }
  end

  def update_profile
    @profile = current_profile
    if @profile.update(profile_params)
      OnboardingCompletedNotificationJob.perform_later(@profile.id)
      redirect_to root_path, notice: "Profile saved successfully!"
    else
      load_form_data
      render :profile, status: :unprocessable_entity
    end
  end

  private

  def find_or_build_session_profile
    if Current.user
      @profile = Current.user.candidate_profile || Current.user.build_candidate_profile
    else
      @profile = session_profile
    end
  end

  def session_profile
    if session[:candidate_profile_id]
      CandidateProfile.find_by(id: session[:candidate_profile_id])
    else
      guest_user = User.create!(
        email_address: "guest_#{SecureRandom.hex(8)}@temp.invalid",
        password: SecureRandom.hex(16)
      )
      profile = guest_user.create_candidate_profile!
      session[:candidate_profile_id] = profile.id
      profile
    end
  end

  def current_profile
    if Current.user
      Current.user.candidate_profile
    elsif session[:candidate_profile_id]
      CandidateProfile.find_by(id: session[:candidate_profile_id])
    end
  end

  def load_form_data
    @job_functions = JobFunction.order(:position)
    @all_languages = Language.order(:name)
    @all_regions   = Region.order(:name)
  end

  def profile_params
    params.require(:candidate_profile).permit(
      :first_name, :last_name, :email, :phone_number, :city, :country,
      :job_function_id, :max_travel_time, :search_status, :reason_for_looking,
      :desired_gross_salary, :desired_percentage, :average_daily_revenue,
      :big_registration_status, :big_number, :years_of_experience,
      :available_from, :notice_period, :motivation_for_employer,
      :professional_summary, :consent_given,
      transport_types: [], desired_employment_types: [],
      available_working_days: [], skill_ids: [], language_ids: [], region_ids: [],
      educations_attributes: %i[id institution study_course city_country level start_date end_date _destroy],
      work_experiences_attributes: %i[id job_title company_name responsibilities start_date end_date current_job _destroy]
    )
  end
end
