# frozen_string_literal: true
module Tag::Contracts
  class Create < Reform::Form
    property :name_de
    property :keywords_de
    property :explanations_de
    property :name_en
    property :keywords_en
    property :explanations_en
    property :name_ar
    property :keywords_ar
    property :explanations_ar
    property :name_fa
    property :keywords_fa
    property :explanations_fa
    property :name_fr
    property :name_tr
    property :name_pl
    property :name_ru

    # Validations
    validates :name_de, presence: true
    validates :name_en, presence: true
    validates :explanations_de, length: { maximum: 500 }
    validates :explanations_en, length: { maximum: 500 }
    validates :explanations_ar, length: { maximum: 500 }
    validates :explanations_fa, length: { maximum: 500 }
  end
end
