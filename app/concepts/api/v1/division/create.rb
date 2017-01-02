# frozen_string_literal: true
module API::V1
  module Division
    class Create < Trailblazer::Operation
      include Trailblazer::Operation::Representer, Responder
      representer Representer::Show

      include Model
      model ::Division, :create

      # include Trailblazer::Operation::Policy
      # policy ::DivisionPolicy, :create?

      contract do
        property :name
        property :description
        property :organization_id
        property :section_filter_id

        validates :name, presence: true
        validates :organization_id, presence: true
        validates :section_filter_id, presence: true
      end

      def process(params)
        if validate(params[:json])
          contract.save
        else
          raise 'Division form has errors, which should not happen with'\
                " our user base: #{contract.errors.full_messages}"
        end
      end
    end

    class Update < Create
      # model ::Division, :update
      # policy ::DivisionPolicy, :update?
    end
  end
end
