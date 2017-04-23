# frozen_string_literal: true
module API::V1
  module SectionFilter
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :section_filters

        property :label, getter: ->(section_filter) do
          section_filter[:represented].identifier
        end

        property :identifier
        property :name
      end

      class Index < Show
      end
    end
  end
end
