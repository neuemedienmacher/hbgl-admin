# frozen_string_literal: true
module API::V1
  module User
    class Update < ::User::Update
      include Trailblazer::Operation::Representer, Responder

      representer API::V1::User::Representer::Update
    end
  end
end
