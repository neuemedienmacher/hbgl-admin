# frozen_string_literal: true
# temporary fix for rails_admin: override to_param (return id instead of slug)
# TODO: remove every include of this once we got rid of rails_admin
module RailsAdminParamHack
  extend ActiveSupport::Concern

  included do
    def to_param
      id.to_s
    end
  end
end
