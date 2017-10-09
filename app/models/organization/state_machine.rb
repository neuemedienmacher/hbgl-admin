# frozen_string_literal: true

require ClaratBase::Engine.root.join('app', 'models', 'organization')

module Organization::StateMachine
  extend ActiveSupport::Concern

  included do
    include AASM
    aasm do
      ## States

      state :initialized, initial: true
      state :completed # organization information is complete
      state :approval_process # indicates the beginning of the approval process
      state :approved
      state :all_done # indicates that the organization with all its offers is done

      # Special states object might enter before it is approved
      state :under_construction_pre, # Website under construction pre approve
            after_enter: :deactivate_offers_to_under_construction!

      # Special states object might enter after it was approved
      state :internal_feedback, # There was an issue (internal)
            after_enter: :deactivate_offers!
      state :external_feedback, # There was an issue (external)
            after_enter: :deactivate_offers!
      state :under_construction, # Website under construction post approve
            after_enter: :deactivate_offers_to_under_construction!

      ## Transitions

      event :reinitialize do
        transitions from: :under_construction_pre, to: :initialized
      end

      event :complete do
        transitions from: :initialized, to: :completed
      end

      event :start_approval_process do
        # TODO: reactivate guard!!!
        transitions from: :completed, to: :approval_process # , guard: :different_actor?
      end

      event :approve, before: :set_approved_information do # , success: :generate_translations!
        # TODO: reactivate guard!!!
        transitions from: :approval_process, to: :approved # , guard: :different_actor?
        transitions from: :internal_feedback, to: :approved
        transitions from: :external_feedback, to: :approved
        transitions from: :under_construction, to: :approved
      end

      event :approve_with_deactivated_offers,
            before: :set_approved_information,
            success: :reactivate_offers! do
        # TODO: reactivate guard!!!
        transitions from: :approval_process, to: :approved # , guard: :different_actor?
        transitions from: :internal_feedback, to: :approved
        transitions from: :external_feedback, to: :approved
        transitions from: :under_construction, to: :approved
      end

      event :deactivate_internal do
        transitions from: :approved, to: :internal_feedback
        transitions from: :all_done, to: :internal_feedback
        transitions from: :external_feedback, to: :internal_feedback
      end

      event :deactivate_external do
        transitions from: :approved, to: :external_feedback
        transitions from: :all_done, to: :external_feedback
        transitions from: :internal_feedback, to: :external_feedback
      end

      event :website_under_construction do
        # pre approve
        transitions from: :initialized, to: :under_construction_pre
        transitions from: :completed, to: :under_construction_pre
        # post approve
        transitions from: :approved, to: :under_construction
        transitions from: :all_done, to: :under_construction
        transitions from: :internal_feedback, to: :under_construction
        transitions from: :external_feedback, to: :under_construction
      end

      event :mark_as_done, success: :enable_mailings! do
        transitions from: :approved, to: :all_done
      end
    end

    # When an organization switches from approved to an unapproved state,
    # also deactivate all it's associated visible offers
    def deactivate_offers!
      offers.visible_in_frontend.find_each do |offer|
        next if offer.deactivate_through_organization!
        raise "#deactivate_offers! failed for #{offer.id}"
      end
    end

    # When an organization switches from an approval to approved,
    # also try to approve all it's associated organization_deactivated,
    # expired and under_construction offers
    def reactivate_offers!
      offers.where(aasm_state: %w[organization_deactivated expired
                                  under_construction]).find_each do |o|
        # set checkup state on local offer instance (don't save this)
        o.aasm_state = 'checkup_process'
        # approve is possible (saves the instance). If approve is not possible
        # we don't save the checkup state but keep the deactivation state
        o.approve! if o.may_approve?
      end
    end

    # When an organization switches to a website_under_construction state, the
    # associated visible offers also transitions to under_construction
    def deactivate_offers_to_under_construction!
      offers.visible_in_frontend.find_each do |offer|
        next if offer.website_under_construction!
        raise "#deactivate_offer_to_under_construction failed for #{offer.id}"
      end
    end

    def set_approved_information
      self.approved_at = Time.zone.now
      self.approved_by = Creator::Twin.new(self).current_actor
    end

    def different_actor?
      Creator::Twin.new(self).different_actor?
    end
  end
end
