# frozen_string_literal: true
module API::V1
  module Tag
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :tags

        attributes do
          property :label, getter: ->(filter) do
            filter[:represented].name_de
          end

          property :name_de
          property :keywords_de
          property :explanations_de

          property :name_en
          property :keywords_en
          property :explanations_en

          property :name_ar
          property :keywords_ar
          property :explanations_ar

          property :name_fa
          property :keywords_fa
          property :explanations_fa

          property :name_fr
          property :name_pl
          property :name_tr
          property :name_ru
        end
      end

      class Index < Show
      end

      class Create < Show
      end
    end
  end
end
