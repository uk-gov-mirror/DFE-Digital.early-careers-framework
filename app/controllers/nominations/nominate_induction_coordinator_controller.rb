# frozen_string_literal: true

class Nominations::NominateInductionCoordinatorController < ApplicationController
  def new
    @token = params[:token]
    @nomination_email = NominationEmail.find_by(token: @token)

    if @nomination_email.nil?
      redirect_to link_invalid_nominate_induction_coordinator_path
    elsif @nomination_email.expired?
      redirect_to link_expired_nominate_induction_coordinator_path(school_id: @nomination_email.school_id)
    elsif @nomination_email.school.fully_registered?
      redirect_to already_nominated_request_nomination_invite_path
    else
      load_nominate_induction_tutor_form
      @nominate_induction_tutor_form.token = @token
    end
  end

  def create
    load_nominate_induction_tutor_form

    render :new and return unless @nominate_induction_tutor_form.valid?

    @nominate_induction_tutor_form.save!
    redirect_to nominate_school_lead_success_nominate_induction_coordinator_path
  rescue UserExistsError
    redirect_to email_used_nominate_induction_coordinator_path(token: @nominate_induction_tutor_form.token)
  end

  def link_expired
    @school_id = params[:school_id]
  end

  def resend_email_after_link_expired
    nomination_request_form = build_nomination_request_form
    nomination_request_form.save!

    redirect_to success_request_nomination_invite_path
  rescue TooManyEmailsError
    redirect_to limit_reached_request_nomination_invite_path
  end

  def email_used
    @token = params[:token]
  end

  def nominate_school_lead_success; end

private

  def load_nominate_induction_tutor_form
    @nominate_induction_tutor_form = ::NominateInductionTutorForm.new
    @nominate_induction_tutor_form.assign_attributes(nominate_induction_tutor_form_params)
  end

  def nominate_induction_tutor_form_params
    return {} unless params.key?(:nominate_induction_tutor_form)

    params.require(:nominate_induction_tutor_form).permit(:full_name, :email, :token)
  end

  def build_nomination_request_form
    school = School.find(params[:resend_email_after_link_expired][:school_id])
    NominationRequestForm.new(
      local_authority_id: school.local_authority.id,
      school_id: school.id,
    )
  end
end