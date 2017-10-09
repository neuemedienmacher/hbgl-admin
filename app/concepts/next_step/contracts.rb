# frozen_string_literal: true

module NextStep::Contracts
  class Create < Reform::Form
    property :text_de
    property :text_en
    property :text_ar
    property :text_fr
    property :text_pl
    property :text_tr
    property :text_ru
    property :text_fa

    validates :text_de, presence: true, length: { maximum: 255 }
    validates :text_en, presence: true, length: { maximum: 255 }
    validates :text_ar, length: { maximum: 255 }
    validates :text_fr, length: { maximum: 255 }
    validates :text_pl, length: { maximum: 255 }
    validates :text_tr, length: { maximum: 255 }
    validates :text_ru, length: { maximum: 255 }
    validates :text_fa, length: { maximum: 255 }
  end
end
