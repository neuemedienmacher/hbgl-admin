# frozen_string_literal: true

module API::V1
  module Area
    class Create < ::Area::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Area::Representer::Create
    end

    class Update < ::Area::Update
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Area::Representer::Create
    end
  end
end
