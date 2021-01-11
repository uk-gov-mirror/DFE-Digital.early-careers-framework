# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::Registrations /check_email", type: :request do
  let(:school) { FactoryBot.create(:school) }
  let(:email) { Faker::Internet.email(domain: school.domains.first) }

  describe "GET /users/check_email" do
    it "renders the correct template" do
      get "/users/check_email"
      expect(response).to render_template(:start_registration)
    end
  end

  describe "POST /users/check_email" do
    it "displays a warning when no schools are found" do
      # When
      post "/users/check_email", params: { induction_coordinator_profile: {
        email: "something@random.com",
      } }

      # Then
      expect(response).to redirect_to(:users_check_email)
      follow_redirect!
      expect(response).to render_template(:start_registration)
      expect(response.body).to include("No schools matched your email")
    end

    it "redirect to the school confirmation page when there is one matching school" do
      # When
      post "/users/check_email", params: { induction_coordinator_profile: {
        email: email,
      } }

      # Then
      expect(response.redirect_url).to include(users_confirm_school_path)
      follow_redirect!
      expect(response.body).to include(CGI.escapeHTML(school.name))
    end

    it "redirect to the school confirmation page when there are two matching schools" do
      # Given
      second_school = FactoryBot.create(:school)
      second_school.domains.push(school.domains.first)
      second_school.save!

      # When
      post "/users/check_email", params: { induction_coordinator_profile: {
        email: email,
      } }

      # Then
      expect(response.redirect_url).to include(users_confirm_school_path)
      follow_redirect!
      expect(response.body).to include(CGI.escapeHTML(school.name))
      expect(response.body).to include(CGI.escapeHTML(second_school.name))
    end
  end
end