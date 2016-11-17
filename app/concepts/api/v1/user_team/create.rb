# frozen_string_literal: true
module API::V1
  module UserTeam
    class Create < Trailblazer::Operation
      include Trailblazer::Operation::Representer, Responder
      representer Representer::Show

      include Model
      model ::UserTeam, :create

      include Trailblazer::Operation::Policy
      policy ::UserTeamPolicy, :create?

      contract do
        property :name
        property :user_ids
      end

      def process(params)
        if validate(params[:json])
          contract.save
        else
          raise 'UserTeam form has errors, which should not happen with'\
                " our user base: #{contract.errors.full_messages}"
        end
      end
    end

    class Update < Create
      model ::UserTeam, :update
      policy ::UserTeamPolicy, :update?
    end
  end
end
