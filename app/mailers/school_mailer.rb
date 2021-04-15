# frozen_string_literal: true

class SchoolMailer < ApplicationMailer
  NOMINATION_EMAIL_TEMPLATE = "a7cc4d19-c0cb-4187-a71b-1b1ea029924f"
  NOMINATION_CONFIRMATION_EMAIL_TEMPLATE = "240c5685-5cb0-40a9-9bd4-1a595d991cbc"
  SCHOOL_PARTNERSHIP_NOTIFICATION_EMAIL_TEMPLATE = "99991fd9-fb41-48cf-846d-98a1fee7762a"
  COORDINATOR_PARTNERSHIP_NOTIFICATION_EMAIL_TEMPLATE = "076e8486-cbcc-44ee-8a6e-d2a721ee1460"

  def nomination_email(recipient:, reference:, school_name:, nomination_url:)
    template_mail(
      NOMINATION_EMAIL_TEMPLATE,
      to: recipient,
      reference: reference,
      rails_mailer: mailer_name,
      rails_mail_template: action_name,
      personalisation: {
        school_name: school_name,
        nomination_link: nomination_url,
      },
    )
  end

  def nomination_confirmation_email(user:, school:, start_url:)
    template_mail(
      NOMINATION_CONFIRMATION_EMAIL_TEMPLATE,
      to: user.email,
      rails_mailer: mailer_name,
      rails_mail_template: action_name,
      personalisation: {
        school_name: school.name,
        start_url: start_url,
      },
    )
  end

  def school_partnership_notification_email(recipient:, provider_name:, cohort:, nominate_url:, challenge_url:)
    template_mail(
      SCHOOL_PARTNERSHIP_NOTIFICATION_EMAIL_TEMPLATE,
      to: recipient,
      rails_mailer: mailer_name,
      rails_mail_template: action_name,
      personalisation: {
        provider_name: provider_name,
        cohort: cohort,
        nominate_url: nominate_url,
        challenge_url: challenge_url,
      },
    )
  end

  def coordinator_partnership_notification_email(recipient:, provider_name:, cohort:, start_url:, challenge_url:)
    template_mail(
      COORDINATOR_PARTNERSHIP_NOTIFICATION_EMAIL_TEMPLATE,
      to: recipient,
      rails_mailer: mailer_name,
      rails_mail_template: action_name,
      personalisation: {
        provider_name: provider_name,
        cohort: cohort,
        start_url: start_url,
        challenge_url: challenge_url,
      },
    )
  end

  def self.send_school_partnership_notification_email(recipient:, provider_name:, cohort:, nominate_url:, challenge_url:)
    result = SchoolMailer.school_partnership_notification_email(
      recipient: recipient,
      provider_name: provider_name,
      cohort: cohort,
      nominate_url: nominate_url,
      challenge_url: challenge_url,
    ).deliver_now

    result.delivery_method.response.id
  end

  def self.send_coordinator_partnership_notification_email(recipient:, provider_name:, cohort:, start_url:, challenge_url:)
    result = SchoolMailer.coordinator_partnership_notification_email(
      recipient: recipient,
      provider_name: provider_name,
      cohort: cohort,
      start_url: start_url,
      challenge_url: challenge_url,
    ).deliver_now

    result.delivery_method.response.id
  end
end
