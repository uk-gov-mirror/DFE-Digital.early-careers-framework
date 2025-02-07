# frozen_string_literal: true

FactoryBot.define do
  factory :cohort do
    start_year { Faker::Number.unique.between(from: 2021, to: 2100) }
  end
end
