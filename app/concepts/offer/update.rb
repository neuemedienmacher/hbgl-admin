# frozen_string_literal: true
class Offer::Update < Trailblazer::Operation
  include Offer::CommonSideEffects

  step Model(::Offer, :find_by)
  step Policy::Pundit(PermissivePolicy, :update?)

  step Contract::Build(constant: Offer::Contracts::Update)
  step Contract::Validate()
  step Wrap(::Lib::Transaction) {
    step ::Lib::Macros::Nested::Find :section, ::Section
    step ::Lib::Macros::Nested::Find :split_base, ::SplitBase
    step ::Lib::Macros::Nested::Find :next_steps, ::NextStep
    step ::Lib::Macros::Nested::Create :contact_people, ::ContactPerson::Create
    step ::Lib::Macros::Nested::Create :location, ::Location::Create
    step ::Lib::Macros::Nested::Find :area, ::Area
    step ::Lib::Macros::Nested::Find :categories, ::Category
    step ::Lib::Macros::Nested::Find :tags, ::Tag
    step ::Lib::Macros::Nested::Find :trait_filters, ::TraitFilter
    step ::Lib::Macros::Nested::Find :language_filters, ::LanguageFilter
    step ::Lib::Macros::Nested::Create :target_audience_filters_offers,
                                       ::TargetAudienceFiltersOffer::Create
    step ::Lib::Macros::Nested::Find :openings, ::Opening
    step ::Lib::Macros::Nested::Create :websites, ::Website::Create
    step ::Lib::Macros::Nested::Find :logic_version, ::LogicVersion
  }
  step Contract::Persist()
  step :set_next_steps_sort_value
end
