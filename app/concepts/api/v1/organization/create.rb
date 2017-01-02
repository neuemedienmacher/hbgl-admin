# frozen_string_literal: true
module API::V1
  module Organization
    class Create < Trailblazer::Operation
      include Trailblazer::Operation::Representer, Responder
      representer Representer::Show

      include Model
      model ::Organization, :create

      # include Trailblazer::Operation::Policy
      # policy ::OrganizationPolicy, :create?

      contract do
        property :name
        # property :description
        # property :legal_form
        property :priority

        # property :division_ids
        collection :divisions, populate_if_empty: Division do
          property :name
          property :section_filter_id
        end

        # def divisions!(options)
        #   options[:collection].append(::Division.new)
        # end
      end

      def process(params)
        binding.pry
        if validate(params[:json])
          contract.save
        else
          raise 'Organization form has errors, which should not happen with'\
                " our user base: #{contract.errors.full_messages}"
        end
      end
    end

    class Update < Create
      # model ::Organization, :update
      # policy ::OrganizationPolicy, :update?
    end
  end
end
