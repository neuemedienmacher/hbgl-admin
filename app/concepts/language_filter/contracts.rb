# frozen_string_literal: true
module LanguageFilter::Contracts
  class Create < Filter::Contracts::Create
    property :identifier

    validates :identifier, length: { is: 3 }
  end
end
