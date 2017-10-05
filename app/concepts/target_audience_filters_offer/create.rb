# frozen_string_literal: true
class TargetAudienceFiltersOffer::Create < Trailblazer::Operation
  step Model(::TargetAudienceFiltersOffer, :new)
  step Policy::Pundit(PermissivePolicy, :create?)

  step Contract::Build(constant: TargetAudienceFiltersOffer::Contracts::Create)
  step Contract::Validate()
  step Wrap(::Lib::Transaction) {
    step ::Lib::Macros::Nested::Find :target_audience_filter,
                                     ::TargetAudienceFilter
    step ::Lib::Macros::Nested::Find :offer, ::Offer
  }
  step Contract::Persist()
end
