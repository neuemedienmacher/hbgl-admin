# frozen_string_literal: true
module API::V1
  module UserTeam
    class Create < ::UserTeam::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::UserTeam::Representer::Show
    end

    class Update < ::UserTeam::Update
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::UserTeam::Representer::Show
    end
  end
end
