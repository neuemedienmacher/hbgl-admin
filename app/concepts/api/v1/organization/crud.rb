# frozen_string_literal: true

module API::V1
  module Organization
    class Create < ::Organization::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Organization::Representer::Create
    end

    class Update < ::Organization::Update
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Organization::Representer::Update

      step :assign_to_system_via_button, before: 'persist.save'

      def assign_to_system_via_button(options, model:, params:, **)
        meta = params['meta'] && params['meta']['commit']
        if meta.to_s == 'toSystem' && %w[approved all_done].include?(model.aasm_state)
          ::Assignment::CreateBySystem.(
            {}, assignable: model, last_acting_user: options['current_user']
          ).success?
        else
          true
        end
      end
    end
  end
end
