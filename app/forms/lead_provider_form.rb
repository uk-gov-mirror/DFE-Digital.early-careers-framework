# frozen_string_literal: true

class LeadProviderForm
  include ActiveModel::Model

  attr_accessor :name, :cip, :cohorts
  validates :cip, presence: { message: "Choose one" }, on: :cip
  validates :cohorts, presence: { message: "Choose one or more" }, on: :cohorts

  def available_cips
    CoreInductionProgramme.all
  end

  def available_cohorts
    Cohort.all
  end

  def chosen_cohorts
    Cohort.where(id: cohorts)
  end

  def chosen_cohort_names
    cohorts.map { |id| Cohort.find(id).display_name }
           .join(", ")
  end

  def chosen_cip
    CoreInductionProgramme.find(cip)
  end

  def chosen_cip_name
    CoreInductionProgramme.find(cip).name
  end

  def save!
    lead_provider = LeadProvider.new(name: name, cohorts: chosen_cohorts)

    ActiveRecord::Base.transaction do
      lead_provider.save!
      chosen_cohorts.each do |cohort|
        LeadProviderCip.create!(cohort: cohort, core_induction_programme: chosen_cip, lead_provider: lead_provider)
      end
    end

    lead_provider
  end
end