# frozen_string_literal: true
require 'roar/decorator'
require 'roar/json/json_api'

module API::V1
  module Default
    module Representer
      module NonStrictNaming
        def self.included(base)
          base.defaults do |name, _|
            { as: Roar::JSON::JSONAPI::MemberName.(name, strict: false) }
          end
        end
      end
    end
  end
end
