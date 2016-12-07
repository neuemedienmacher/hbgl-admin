# frozen_string_literal: true
module API::V1
  module BaseTranslation
    class Create < API::V1::Assignable::Create

      contract do
        property :locale
        property :source
        property :possibly_outdated
      end

      def process(params)
        # super call for assignments
        super(params)
      end

      protected

      def assignment_creator_id
        created_by_system? ? ::User.system_user.id : @params[:current_user][:id]
      end

      def assignment_reciever_id
        ::User.system_user.id
      end

      def message_for_new_assignment
        'Initiale Zuweisung für Übersetzungen'
      end

      def created_by_system?
        true
      end
    end
  end
end
