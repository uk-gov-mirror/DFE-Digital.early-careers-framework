# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Schools", type: :request do
  before do
    user = create(:user, :admin)
    sign_in user
  end

  describe "GET /admin/schools" do
    it "renders the schools template" do
      get "/admin/schools"

      expect(response).to render_template("admin/schools/index")
    end

    it "only displays eligible schools" do
      eligible_school = create(:school)
      ineligible_school = create(:school, school_status_code: 2)

      get "/admin/schools"
      expect(response.body).to include(eligible_school.urn)
      expect(response.body).not_to include(ineligible_school.urn)
    end

    it "filters the list of schools by name" do
      included_school = create(:school, name: "Include Me")
      excluded_school = create(:school, name: "Exclude Me")

      get "/admin/schools", params: { query: "include" }
      expect(response.body).to include(included_school.urn)
      expect(response.body).not_to include(excluded_school.urn)
    end

    it "filters the list of schools by urn" do
      included_school = create(:school, name: "Include Me")
      excluded_school = create(:school, name: "Exclude Me")

      get "/admin/schools", params: { query: included_school.urn }
      expect(response.body).to include(included_school.urn)
      expect(response.body).not_to include(excluded_school.urn)
    end
  end

  describe "GET /admin/schools/:id" do
    let(:school) { create(:school) }

    it "renders the schools show template" do
      get "/admin/schools/#{school.id}"

      expect(response).to render_template("admin/schools/show")
      expect(response.body).to include(school.name)
      expect(response.body).to include("Add induction tutor")
    end

    context "when school is registered" do
      let!(:induction_coordinator) do
        create(:user, :induction_coordinator, schools: [school])
      end

      it "renders the induction coordinator's details" do
        get "/admin/schools/#{school.id}"

        expect(response.body).not_to include("Add induction tutor")
        expect(response.body).to include(induction_coordinator.email)
        expect(response.body).to include(induction_coordinator.full_name)
      end
    end
  end
end
