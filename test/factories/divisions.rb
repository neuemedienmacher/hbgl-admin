# frozen_string_literal: true

FactoryBot.define do
  factory :division do
    addition 'default division addition'
    label 'default division label'
    city { City.all.sample }
    organization { FactoryBot.create(:organization, :approved) }

    # associations
    transient do
      section nil
    end

    after :build do |division, evaluator|
      division.section =
        evaluator.section || Section.first || FactoryBot.create(:section)
    end

    after :create do |division, _evaluator|
      division.label = division.label + ' ' + division.organization.name
      division.assignments << ::Assignment::CreateBySystem.(
        {},
        assignable: division,
        last_acting_user: User.find(division.organization.created_by)
      )['model']
    end
  end
end
