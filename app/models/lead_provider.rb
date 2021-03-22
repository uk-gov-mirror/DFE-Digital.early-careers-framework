# frozen_string_literal: true

# == Schema Information
#
# Table name: lead_providers
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class LeadProvider < ApplicationRecord
  has_many :partnerships
  has_many :schools, through: :partnerships
  has_many :lead_provider_profiles
  has_many :users, through: :lead_provider_profiles
  has_many :provider_relationships
  has_many :delivery_partners, through: :provider_relationships
  has_and_belongs_to_many :cohorts
  has_many :lead_provider_cips
  has_many :core_induction_programmes, through: :lead_provider_cips

  validates :name, presence: { message: "Enter a name" }
end
