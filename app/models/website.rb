# frozen_string_literal: true
# Monkeypatch clarat_base Website
require ClaratBase::Engine.root.join('app', 'models', 'website')

class Website < ActiveRecord::Base
  # Scopes
  scope :unreachable, -> { where('unreachable_count > ?', 0) }

  # Search
  include PgSearch
  pg_search_scope :search_everything,
                  against: [:id, :host],
                  using: { tsearch: { prefix: true } }

  # Validation Hack
  include ReformedValidationHack

  # Methods

  def ascii_url
    # this is okay because the prefix must be http:// oder https:// (Validations)
    splitted_url = url.split('/')
    # because of the validations, the third item must be the host, so we replace
    # it. This is required, because SimpleIDN only works on host-urls and breaks
    # path-URLs
    splitted_url[2] = SimpleIDN.to_ascii(splitted_url[2])
    # decode and encode the rest (path) of the URL to be ascii conform
    splitted_url[3..splitted_url.length].each_with_index do |item, index|
      # splitted_url[index + 3] = URI.encode(URI.decode(item))
      # # hotfix for '#' => %23 ascii is wrong and leads to false positives
      # splitted_url[index + 3].gsub!('%23', '#')
      splitted_url[index + 3] = decode_encode_url_part(item)
    end
    # after replacement, just re-join the array again and append last / if
    # it was there before (removed by .split)
    splitted_url.join('/') + (url.last == '/' ? '/' : '')
  end

  private

  def decode_encode_url_part item
    encoded_decoded = URI.encode(URI.decode(item))
    # hotfix for '#' => %23 ascii is wrong and leads to false positives
    encoded_decoded.gsub('%23', '#')
  end
end
