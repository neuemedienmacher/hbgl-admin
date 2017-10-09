# frozen_string_literal: true

module Translation
  class Twin < Disposable::Twin
    # Methods

    def should_be_reviewed_by_translator?
      (model.possibly_outdated || model.source == 'GoogleTranslate') &&
        model.translated_model.in_section?('refugees') &&
        model.manually_editable?
    end

    def currently_assigned_to_system_user?
      current_assignment = model.current_assignment
      current_assignment.nil? == false && current_assignment.receiver_id ==
        ::User.system_user.id
    end
  end
end
