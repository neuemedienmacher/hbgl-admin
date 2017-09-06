# frozen_string_literal: true
module API::V1
  module Tag
    class Create < ::Tag::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Tag::Representer::Create
    end
  end
end
