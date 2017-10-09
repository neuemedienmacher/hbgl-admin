# frozen_string_literal: true

module API::V1
  module Offer
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :offers

        attributes do
          property :label, getter: ->(offer) do
            offer[:represented].name
          end
          property :name
          property :description
          property :old_next_steps
          property :opening_specification
          property :encounter
          property :slug
          property :created_at
          property :updated_at
          property :approved_at
          property :created_by
          property :approved_by
          property :description_html
          property :next_steps_html
          property :opening_specification_html
          property :target_audience
          property :aasm_state
          property :hide_contact_people
          property :starts_at
          property :ends_at
          property :completed_at
          property :completed_by
          property :comment

          property :section_id
          property :logic_version_id
          property :split_base_id
          property :category_ids
          property :location_id
          property :area_id
          property :contact_person_ids
          property :target_audience_filters_offer_ids
          property :language_filter_ids
          property :trait_filter_ids
          property :tag_ids
          property :opening_ids
          property :next_step_ids
          property :website_ids
        end

        has_one :section do
          type :sections

          attributes do
            property :label, getter: ->(o) { o[:represented].identifier }
            property :name
            property :identifier
          end
        end

        has_many :target_audience_filters_offers, # sent in show for duplication
                 decorator:
                   API::V1::TargetAudienceFiltersOffer::Representer::Show,
                 populator: API::V1::Lib::Populators::FindOrInstantiate,
                 class: ::TargetAudienceFiltersOffer

        link(:preview) do
          ::RemoteShow.build_preview_link(
            :angebote, represented.section.identifier, represented
          )
        end
      end

      class Index < Show
      end

      class Create < Show
        has_many :next_steps,
                 decorator: API::V1::NextStep::Representer::Show,
                 populator: API::V1::Lib::Populators::FindOrInstantiate,
                 class: ::NextStep

        has_many :contact_people,
                 decorator: API::V1::ContactPerson::Representer::Create,
                 populator: API::V1::Lib::Populators::FindOrInstantiate,
                 class: ::ContactPerson

        has_many :language_filters,
                 decorator: API::V1::Filter::Representer::Show,
                 populator: API::V1::Lib::Populators::FindOrInstantiate,
                 class: ::LanguageFilter

        has_many :trait_filters,
                 decorator: API::V1::Filter::Representer::Show,
                 populator: API::V1::Lib::Populators::FindOrInstantiate,
                 class: ::TraitFilter

        has_one :location,
                decorator: API::V1::Location::Representer::Create,
                populator: API::V1::Lib::Populators::FindOrInstantiate,
                class: ::Location

        has_one :area,
                decorator: API::V1::Area::Representer::Show,
                populator: API::V1::Lib::Populators::FindOrInstantiate,
                class: ::Area

        has_one :split_base,
                decorator: API::V1::SplitBase::Representer::Show,
                populator: API::V1::Lib::Populators::FindOrInstantiate,
                class: ::SplitBase

        has_many :categories,
                 decorator: API::V1::Category::Representer::Show,
                 # populator: API::V1::Lib::Populators::FindOrInstantiate,
                 class: ::Category

        has_many :tags,
                 decorator: API::V1::Tag::Representer::Show,
                 populator: API::V1::Lib::Populators::FindOrInstantiate,
                 class: ::Tag

        has_one :section,
                decorator: API::V1::Section::Representer::Show,
                populator: API::V1::Lib::Populators::FindOrInstantiate,
                class: ::Section

        has_many :openings,
                 decorator: API::V1::Opening::Representer::Show,
                 populator: API::V1::Lib::Populators::FindOrInstantiate,
                 class: ::Opening

        has_many :websites,
                 decorator: API::V1::Website::Representer::Show,
                 populator: API::V1::Lib::Populators::FindOrInstantiate,
                 class: ::Website
      end

      class Update < Create
      end
    end
  end
end
