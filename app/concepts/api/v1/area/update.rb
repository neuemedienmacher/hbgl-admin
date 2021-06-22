# frozen_string_literal: true

module API::V1
  module Area
    class Update < ::Area::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Area::Representer::Show
    end
  end
end
