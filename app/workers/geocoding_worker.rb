# frozen_string_literal: true
class GeocodingWorker
  include Sidekiq::Worker

  def perform location_id
    loc = Location.find(location_id)
    old_geoloc = Geolocation.new loc

    # call geocoding gem (API)
    loc.geocode

    # ensure location now has coordinates
    if loc.latitude && loc.longitude
      # NOTE: update_columns (enforce DB-write)
      loc.update_columns longitude: loc.longitude, latitude: loc.latitude
      # update offer (_geoloc) index after coordinates changed
      loc.offers.to_a.map(&:index!) if old_geoloc != Geolocation.new(loc)
    else
      raise 'Geocoding failed'
    end
  end
end
