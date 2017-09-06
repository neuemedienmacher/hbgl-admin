# frozen_string_literal: true
module API::V1
  module Tag
    class Update < ::Tag::Update
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Tag::Representer::Update
    end
  end
end
