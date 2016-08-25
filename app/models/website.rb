# frozen_string_literal: true
# Monkeypatch clarat_base Website
require ClaratBase::Engine.root.join('app', 'models', 'website')

class Website < ActiveRecord::Base
  # Scopes
  scope :unreachable, -> { where('unreachable_count > ?', 0) }

  # Methods

  def ascii_url
    # this is okay because the prefix must be http:// oder https:// (Validations)
    splitted_url = url.split('/')
    # because of the validations, the third item must be the host, so we replace
    # it. This is required, because SimpleIDN only works on host-urls and breaks
    # path-URLs
    splitted_url[2] = SimpleIDN.to_ascii(splitted_url[2])
    # after replacement, just re-join the array again
    splitted_url.join('/')
  end
end
