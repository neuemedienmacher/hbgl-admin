# frozen_string_literal: true

class Division::Delete < Default::Delete
  include SyncOrganization
  step :abort_with_connected_offers, before: 'destroy_record'
  step :syncronize_organization_approve_or_done_state, after: 'destroy_record'

  def abort_with_connected_offers(_, model:, **)
    model.offers.empty?
  end
end
