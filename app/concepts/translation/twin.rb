# frozen_string_literal: true
module Translation
  class Twin < Disposable::Twin
    # Methods

    def should_be_reviewed_by_translator?
      (model.possibly_outdated || model.source == 'GoogleTranslate') &&
        model.translated_model.in_section?('refugees') &&
        model.manually_editable?
    end

    def already_assigned_to_translator_team?
      current_assignment = ::Assignable::Twin.new(model).current_assignment
      current_assignment.nil? == false && current_assignment.receiver_team_id ==
        AssignmentDefaults.translator_teams[model.locale.to_s]
    end
  end
end
