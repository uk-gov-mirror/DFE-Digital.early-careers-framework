# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Report schools spec", type: :request do
  let(:user) { create(:user, :lead_provider) }

  before do
    create(:cohort, start_year: 2021)
  end

  describe "GET /lead-providers/report-schools/start" do
    it "should show the start page to a lead provider" do
      sign_in user
      get start_lead_providers_report_schools_path

      expect(response).to render_template :start
    end
  end
end
