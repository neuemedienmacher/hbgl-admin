# frozen_string_literal: true
# Monkeypatch clarat_base Offer
require ClaratBase::Engine.root.join('app', 'models', 'opening')
# Opening Times of Offers
class Opening < ActiveRecord::Base
end
