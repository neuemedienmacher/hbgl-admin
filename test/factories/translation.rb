FactoryGirl.define do
  factory :translation do
    locale 'de'
    source 'GoogleTranslate'
    offer

    factory :offer_translation, class: 'OfferTranslation' do
      name 'default offer_translation name'
      description 'default offer_translation description'
    end

    factory :organization_translation do
      name 'default organization_translation name'
      description 'default organization_translation description'
    end
  end
end
