# frozen_string_literal: true

class Location::Update < Location::Create
  step Model(::Location, :find_by), replace: 'model.build'
  step :reindex_offers_on_visible_change

  def geocode!(options, model:, **)
    contract = options['contract.default']
    important_keys = %w[street zip city_id federal_state_id]
    if important_keys.map { |k| contract.changed[k] }.any?
      GeocodingWorker.perform_async model.id
    end
    true
  end

  def reindex_offers_on_visible_change(options, model:, **)
    if options['contract.default'].changed['visible']
      model.offers.visible_in_frontend.find_each(&:index!)
    end
    true
  end
end
