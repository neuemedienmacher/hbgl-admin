# frozen_string_literal: true
FactoryGirl.define do
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

    after :build do |translation, _evaluator|
      translation.assignments << ::Assignment::CreateBySystem.(
        {},
        assignable: translation,
        last_acting_user: User.first || FactoryGirl.create(:researcher)
      )['model']
    end
  end
end
