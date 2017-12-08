# frozen_string_literal: true

require 'ffaker'

FactoryBot.define do
  factory :organization do
    # required
    name { FFaker::Lorem.words(rand(2..3)).join(' ').titleize }
    description { FFaker::Lorem.paragraph(rand(4..6))[0..399] }
    legal_form do
      Organization.enumerized_attributes.attributes['legal_form'].values.sample
    end
    charitable { FFaker::Boolean.maybe }
    website { FactoryBot.create(:website, host: 'own') }

    # optional
    founded { maybe((1980..Time.zone.now.year).to_a.sample) }
    mailings 'enabled'
    created_by { FactoryBot.create(:researcher).id }

    # associations
    transient do
      location_count 1
      section nil
    end

    after :build do |orga|
      # Filters
      orga.umbrella_filters << (
        UmbrellaFilter.all.sample ||
          UmbrellaFilter.create(identifier: 'diakonie', name: 'Diakonie')
      )

      # # Contact People
      # create_list :contact_person, evaluator.contact_person_count,
      #             organization: orga
    end

    after :create do |orga, evaluator|
      # Locations
      if evaluator.location_count.positive?
        orga.locations << FactoryBot.create(:location, :hq, organization: orga)
      end
      if evaluator.location_count > 1
        create_list :location, (evaluator.location_count - 1),
                    organization: orga, hq: false
      end
      orga.assignments << ::Assignment::CreateBySystem.(
        {},
        assignable: orga,
        last_acting_user: User.find(orga.created_by)
      )['model']
      # create default division for random section
      section = if evaluator.section
                  Section.find_by(identifier: evaluator.section)
                else
                  Section.all.sample
                end
      orga.divisions << FactoryBot.create(
        :division, organization: orga, section: section
      )
    end

    # traits
    trait :approved do
      after :create do |orga, _evaluator|
        Organization.where(id: orga.id).update_all aasm_state: 'approved',
                                                   approved_at: Time.zone.now
        orga.reload
      end
      approved_by { FactoryBot.create(:researcher).id }
      approved_at { Time.zone.now }
    end

    trait :mailings_disabled do
      mailings 'force_disabled'
    end

    trait :with_translation do
      after :create do |orga, _evaluator|
        orga.generate_translations!
      end
    end
  end
end

def maybe result
  rand(2).zero? ? nil : result
end
