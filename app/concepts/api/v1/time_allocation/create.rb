# frozen_string_literal: true
module API::V1
  module TimeAllocation
    class Create < Trailblazer::Operation
      include Trailblazer::Operation::Representer, Responder
      representer Representer::Show

      def contract!(model=nil, _contract_class=nil)
        @_contract ||=
          if model.new_record?
            Contracts::Create.new(model)
          else
            Contracts::Update.new(model)
          end
      end

      def find_model(params)
        @model ||=
          if params[:id]
            ::TimeAllocation.find(params[:id])
          else
            ::TimeAllocation.new
          end
      end

      def process(params)
        if validate(params[:json], find_model(params))
          contract.save
        else
          raise 'TimeAllocation form has errors, which should not happen with'\
                " our user base: #{contract.errors.full_messages}"
        end
      end
    end
  end
end
