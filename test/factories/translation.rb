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

    after :build do |translation, evaluator|
      translation.assignments << ::Assignment::CreateBySystem.(
        {},
        assignable: translation,
        last_acting_user: User.first || FactoryGirl.create(:researcher)
      )['model']
    end
  end
end
