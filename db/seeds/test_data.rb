# frozen_string_literal: true

DOMAIN = "@digital.education.gov.uk" # Prevent low effort email scraping

local_authority = LocalAuthority.find_or_create_by!(name: "ZZ Test Local Authority", code: "ZZTEST")

School.find_or_create_by!(urn: "000001") do |school|
  school.update!(
    name: "ZZ Test School 1",
    postcode: "AA1 1AA",
    address_line1: "1 Nowhere lane",
    primary_contact_email: "cpd-test+school-1#{DOMAIN}",
    school_status_code: 1,
    school_type_code: 1,
    administrative_district_code: "E123",
  )
  SchoolLocalAuthority.find_or_create_by!(school: school, local_authority: local_authority, start_year: 2019)
end

School.find_or_create_by!(urn: "000002") do |school|
  school.update!(
    name: "ZZ Test School 2",
    postcode: "AA2 2AA",
    address_line1: "2 Nowhere lane",
    primary_contact_email: "cpd-test+school-2#{DOMAIN}",
    school_status_code: 1,
    school_type_code: 1,
    administrative_district_code: "E123",
  )
  SchoolLocalAuthority.find_or_create_by!(school: school, local_authority: local_authority, start_year: 2019)
end

School.find_or_create_by!(urn: "000003") do |school|
  school.update!(
    name: "ZZ Test School 3",
    postcode: "AA3 3AA",
    address_line1: "3 Nowhere lane",
    primary_contact_email: "cpd-test+school-3#{DOMAIN}",
    school_status_code: 1,
    school_type_code: 1,
    administrative_district_code: "E123",
  )
  SchoolLocalAuthority.find_or_create_by!(school: school, local_authority: local_authority, start_year: 2019)
  NominationEmail.find_or_create_by!(
    token: "abc123",
    sent_to: "cpd-test+school-3#{DOMAIN}",
    sent_at: 1.year.ago,
    school: school,
  )
end

School.find_or_create_by!(urn: "000004") do |school|
  school.update!(
    name: "ZZ Test School 4",
    postcode: "AA4 4AA",
    address_line1: "4 Nowhere lane",
    primary_contact_email: "cpd-test+school-4#{DOMAIN}",
    school_status_code: 1,
    school_type_code: 1,
    administrative_district_code: "E123",
  )
  SchoolLocalAuthority.find_or_create_by!(school: school, local_authority: local_authority, start_year: 2019)
  user = User.find_or_create_by!(full_name: "Induction Tutor for School 4", email: "cpd-test+tutor-1#{DOMAIN}")
  InductionCoordinatorProfile.find_or_create_by!(user: user) do |profile|
    profile.update!(schools: [school])
  end
  SchoolCohort.find_or_create_by!(cohort: Cohort.current, school: school, induction_programme_choice: "core_induction_programme")
end

School.find_or_create_by!(urn: "000005") do |school|
  school.update!(
    name: "ZZ Test School 5",
    postcode: "AA4 4AA",
    address_line1: "4 Nowhere lane",
    primary_contact_email: "cpd-test+school-5#{DOMAIN}",
    school_status_code: 1,
    school_type_code: 1,
    administrative_district_code: "E123",
  )
  SchoolLocalAuthority.find_or_create_by!(school: school, local_authority: local_authority, start_year: 2019)
  user = User.find_or_create_by!(full_name: "Induction Tutor for School 5", email: "cpd-test+tutor-2#{DOMAIN}")
  InductionCoordinatorProfile.find_or_create_by!(user: user) do |profile|
    profile.update!(schools: [school])
  end
  SchoolCohort.find_or_create_by!(cohort: Cohort.current, school: school, induction_programme_choice: "full_induction_programme")
end
