# frozen_string_literal: true

module API::V1
  module LogicVersion
    class Create < ::LogicVersion::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::LogicVersion::Representer::Create
    end

    class Update < ::LogicVersion::Update
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::LogicVersion::Representer::Create
    end
  end
end
