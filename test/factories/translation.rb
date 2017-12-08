# frozen_string_literal: true

FactoryBot.define do
  factory :translation do
    locale 'de'
    source 'GoogleTranslate'

    factory :offer_translation, class: 'OfferTranslation' do
      offer
      name 'default offer_translation name'
      description 'default offer_translation description'
    end

    factory :organization_translation, class: 'OrganizationTranslation' do
      organization
      description 'default organization_translation description'
    end

    after :create do |translation, _evaluator|
      translation.assignments << ::Assignment::CreateBySystem.(
        {},
        assignable: translation,
        last_acting_user:
          if translation.try(:offer)
            User.find(translation.offer.created_by)
          else
            User.find(translation.organization.created_by)
          end
      )['model']
    end
  end
end
