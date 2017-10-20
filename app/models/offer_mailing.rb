# frozen_string_literal: true

# Connector Model between Offers and Emails, generated when a mailing is sent to
# an Email about an Offer. This is so we can know which offers an Email has
# already been informed about.
class OfferMailing < ApplicationRecord
  # Enumerization
  extend Enumerize
  enumerize :mailing_type, in: %w[inform newly_approved orga_inform]

  # Associations
  belongs_to :offer, inverse_of: :offer_mailings
  belongs_to :email, inverse_of: :offer_mailings
end
