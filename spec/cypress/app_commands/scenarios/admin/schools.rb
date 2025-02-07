# frozen_string_literal: true

school = FactoryBot.create(:school, name: "Include this school", urn: 123_456)
local_authority = FactoryBot.create(:local_authority)
SchoolLocalAuthority.create!(school: school, local_authority: local_authority, start_year: 2021)
FactoryBot.create(:user, :induction_coordinator, full_name: "Sarah Smith", email: "sarah.smith@example.com", schools: [school])

Faker::UniqueGenerator.clear
Faker::Config.random = Random.new(42)
FactoryBot.create_list(:school, 20)
Faker::Config.random = nil
