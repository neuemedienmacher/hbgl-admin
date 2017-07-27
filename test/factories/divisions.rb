# frozen_string_literal: true
FactoryGirl.define do
  factory :division do
    name 'default division name'
    section { Section.all.sample }
    city { City.all.sample }
    organization { FactoryGirl.create(:organization, :approved) }

    after :create do |division, _evaluator|
      division.assignments << ::Assignment::CreateBySystem.(
        {},
        assignable: division,
        last_acting_user: User.find(division.organization.created_by)
      )['model']
    end
  end
end
