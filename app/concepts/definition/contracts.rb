# frozen_string_literal: true

module Definition::Contracts
  class Create < Reform::Form
    property :key
    property :explanation

    validates :key, presence: true,
                    exclusion: { in: %w[dfn class JS tooltip data id] },
                    length: { maximum: 400 }
    validates_uniqueness_of :key
    validates :explanation, presence: true, length: { maximum: 500 }
  end
end
