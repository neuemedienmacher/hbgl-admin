# frozen_string_literal: true
class Organization::Create < Trailblazer::Operation
  step Model(::Organization, :new)

  step Contract::Build()
  step Contract::Validate()
  step Contract::Persist()

  # policy ::OrganizationPolicy, :create?

  extend Contract::DSL
  contract do
    property :name
    # property :description
    # property :legal_form
    property :priority

    # property :division_ids
    collection :divisions, populate_if_empty: Division do
      property :name
      property :section_id
    end

    # def divisions!(options)
    #   options[:collection].append(::Division.new)
    # end
  end
end
