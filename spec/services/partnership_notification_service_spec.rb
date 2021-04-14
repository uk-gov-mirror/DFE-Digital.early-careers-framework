# frozen_string_literal: true

require "rails_helper"

RSpec.describe PartnershipNotificationService do
  subject(:partnership_notification_service) { described_class.new }
  before do
    @lead_provider = create(:lead_provider)
    @delivery_partner = create(:delivery_partner)
    @cohort = create(:cohort, start_year: 2021)
    ProviderRelationship.create!(lead_provider: @lead_provider, delivery_partner: @delivery_partner, cohort: @cohort)
  end

  let(:partnership) do
    Partnership.create!(
      lead_provider: @lead_provider,
      delivery_partner: @delivery_partner,
      cohort: @cohort,
      school: school,
    )
  end
  let(:partnership_notification_email) { partnership.partnership_notification_emails.last }
  let(:notify_id) { Faker::Alphanumeric.alphanumeric(number: 16) }

  describe "#run" do
    context "when the school has no induction coordinator" do
      let(:contact_email) { Faker::Internet.email }
      let(:school) { create(:school, primary_contact_email: contact_email) }

      it "emails the school primary contact" do
        expect(SchoolMailer).to receive(:send_partnership_notification_email).with(
          hash_including(
            provider_name: @delivery_partner.name,
            start_url: String,
            challenge_url: String,
            recipient: contact_email,
          ),
        ).and_return(notify_id)

        partnership_notification_service.notify(partnership)

        expect(partnership_notification_email.sent_to).to eql contact_email
        expect(partnership_notification_email.notify_id).to eql notify_id
      end
    end

    context "when the school has an induction coordinator" do
      let(:contact_email) { Faker::Internet.email }
      let(:school) { create(:school) }
      before do
        create(:user, :induction_coordinator, schools: [school], email: contact_email)
      end

      it "emails the induction coordinator" do
        expect(SchoolMailer).to receive(:send_partnership_notification_email).with(
          hash_including(
            provider_name: @delivery_partner.name,
            start_url: String,
            challenge_url: String,
            recipient: contact_email,
          ),
        ).and_return(notify_id)

        partnership_notification_service.notify(partnership)

        expect(partnership_notification_email.sent_to).to eql contact_email
        expect(partnership_notification_email.notify_id).to eql notify_id
      end
    end
  end
end
