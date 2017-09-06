# frozen_string_literal: true
module SplitBase::Contracts
  class Create < Reform::Form
    property :title
    property :clarat_addition
    property :solution_category
    property :divisions
    property :comments

    validates :title, presence: true
    validate :unique_with_divisions
    validates :solution_category, presence: true

    def unique_with_divisions
      same_split_bases = SplitBase.where(
        title: title, clarat_addition: clarat_addition,
        solution_category_id: solution_category&.id
      )
      if same_split_bases.any?
        own_divisions = divisions.map(&:id)
        check_for_divisions same_split_bases, own_divisions
      end
    end

    def check_for_divisions same_split_bases, own_divisions
      same_split_bases.each do |sb|
        same_sb_divisions = sb.divisions.pluck(:id)
        message = I18n.t('errors.messages.taken')
        next unless own_divisions.sort == same_sb_divisions.sort
        errors.add :title, message
        errors.add :clarat_addition, message
        errors.add :solution_category, message
      end
    end
  end

  class Update < Create
  end
end
