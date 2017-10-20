# frozen_string_literal: true

class OfferTranslation::Create < Trailblazer::Operation
  include Assignable::CommonSideEffects::CreateNewAssignment

  step Model(::OfferTranslation, :new)

  step Contract::Build(constant: OfferTranslation::Contracts::Update)
  step Contract::Validate()
  step Contract::Persist()
  step :create_initial_assignment!
  step :reindex_offer

  def reindex_offer(*, model:, **)
    model.offer.reload.algolia_index!
    true # algolia_index! always returns nil
  end
end
