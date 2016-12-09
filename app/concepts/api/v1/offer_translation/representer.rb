# frozen_string_literal: true
module API::V1
  module OfferTranslation
    module Representer
      class Show < API::V1::Assignable::Representer::Show
        type :offer_translations

        property :label, getter: ->(ot) do
          "##{ot[:represented].id} (#{ot[:represented].locale})"
        end
        property :offer_id
        property :locale
        property :source
        property :name
        property :description
        property :opening_specification
        property :possibly_outdated
        property :created_at
        property :updated_at

        has_one :offer do
          type :offers

          property :id
          property :name
          property :approved_at
          property :created_by
          property :description
          property :opening_specification
        end
      end

      class Index < Show
        link :self, toplevel: true do
          '//offer_translations'
          # bowl_url(opts[:bowl], :page => current_page)
        end
      end
    end
  end
end
