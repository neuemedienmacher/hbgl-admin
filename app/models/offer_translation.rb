# frozen_string_literal: true
# Monkeypatch clarat_base OfferTranslation
require ClaratBase::Engine.root.join('app', 'models', 'offer_translation')

class OfferTranslation < ActiveRecord::Base
  # Search
  include PgSearch
  pg_search_scope :search_everything,
                  against: [
                    :id, :offer_id, :name, :locale, :source
                  ],
                  using: { tsearch: { prefix: true } }

  # Assignment callbacks
  # after_create :create_system_or_translator_team_assignment
  # after_update :create_new_assignment_if_required

  # private
  #
  # def create_system_or_translator_team_assignment
  #   # ... or system user (assigns itself)
  #   # puts '==================CREATE======================'
  #   self.create_assignment_and_close_current!(
  #     AssignmentDefaults['system_user'], nil,
  #     AssignmentDefaults['system_user'], nil,
  #     message = 'I got this!'
  #   )
  # end
  #
  # def create_new_assignment_if_required
  # # puts '==================UPDATE======================'
  #   if manually_editable? &&
  #     (source_changed? && self.source == 'GoogleTranslate') ||
  #     (possibly_outdated_changed? && possibly_outdated)
  #     # puts '==================NEW ASSIGNMENT======================'
  #     # create new assignment from system for the responsible translator-team
  #     # with the reason (outdated or GoogleTranslate) as the message
  #     self.create_assignment_and_close_current!(
  #       AssignmentDefaults['system_user'], nil, nil,
  #       AssignmentDefaults.translator_teams[locale.to_s],
  #       message = possibly_outdated ? 'Veraltet' : self.source
  #     )
  #   end
  # end
end
