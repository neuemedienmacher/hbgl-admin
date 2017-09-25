# frozen_string_literal: true
require ClaratBase::Engine.root.join('app', 'models', 'offer')

module Offer::SearchAlgolia
  extend ActiveSupport::Concern

  included do
    include AlgoliaSearch

    algoliasearch do
      I18n.available_locales.each do |locale|
        index = %w(
          name description code_word next_steps category_keywords definitions
          organization_names category_names stamps_string tags
          category_explanations
        )
        attributes = [:organization_count, :location_address, :location_name,
                      :slug, :encounter, :organization_names, :location_visible,
                      :code_word]
        facets = [:_age_filters, :_language_filters, :_target_audience_filters,
                  :_exclusive_gender_filters, :section_identifier,
                  :_residency_status_filters]

        add_index Offer.personal_index_name(locale),
                  disable_indexing: Rails.env.test?,
                  if: :personal_indexable? do
          attributesToIndex index
          ranking %w(typo geo words proximity attribute exact custom)
          attribute(:name) { send("name_#{locale}") }
          attribute(:description) { send("description_#{locale}") }
          attribute(:next_steps)  { _next_steps locale }
          attribute(:lang) { lang(locale) }
          attribute(:tags) { tag_string(locale) }
          attribute(:definitions) { definitions_string(locale) }
          attribute(:_tags) { _categories(locale) }
          attribute(:stamps_string) { stamps_string(locale) }
          attribute(:singular_stamp) { singular_stamp(locale) }
          attribute(:category_names) { category_names(locale) }
          attribute(:category_keywords) { category_keywords(locale) }
          attribute(:category_explanations) { category_explanations(locale) }
          add_attribute(*attributes)
          add_attribute(*facets)
          add_attribute :_geoloc
          attributesForFaceting facets + [:_tags]
          optionalWords STOPWORDS
        end

        add_index Offer.remote_index_name(locale),
                  disable_indexing: Rails.env.test?,
                  if: :remote_indexable? do
          attributesToIndex index
          attribute(:name) { send("name_#{locale}") }
          attribute(:description) { send("description_#{locale}") }
          attribute(:next_steps)  { _next_steps locale }
          attribute(:lang) { lang(locale) }
          attribute(:tags) { tag_string(locale) }
          attribute(:definitions) { definitions_string(locale) }
          attribute(:_tags) { _categories(locale) }
          attribute(:stamps_string) { stamps_string(locale) }
          attribute(:singular_stamp) { singular_stamp(locale) }
          attribute(:category_names) { category_names(locale) }
          attribute(:category_keywords) { category_keywords(locale) }
          add_attribute(*attributes)
          add_attribute :area_minlat, :area_maxlat, :area_minlong,
                        :area_maxlong
          add_attribute(*facets)
          attributesForFaceting facets + [:_tags, :encounter]
          optionalWords STOPWORDS

          # no geo necessary
          ranking %w(typo words proximity attribute exact custom)
        end
      end
    end
  end
end
