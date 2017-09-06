# frozen_string_literal: true
module Opening::Contracts
  class Create < Reform::Form
    property :day
    property :open
    property :close

    validates :day, presence: true
    validate :unique_day_open_close
    validates :open, presence: true, if: :close
    validates :close, presence: true, if: :open

    def unique_day_open_close
      if Opening.where(day: day, open: open, close: close).any?
        errors.add :day, I18n.t('errors.messages.taken')
        errors.add :open, I18n.t('errors.messages.taken')
        errors.add :close, I18n.t('errors.messages.taken')
      end
    end
  end

  class Update < Reform::Form
    # NOTE only for old Backend (association with offer triggers Update contract
    # => uniqueness fails)
  end
end
