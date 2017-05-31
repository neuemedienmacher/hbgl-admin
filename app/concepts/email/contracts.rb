# frozen_string_literal: true
module Email::Contracts
  class Create < Reform::Form
    property :address
    property :aasm_state
    property :security_code

    # Validations
    # no whitespaces allowed.. whitespacec are theoratically allowed within " "
    # but we simply won't allow them because they cause too many problems at the
    # beginning or end of the address
    validates :address, presence: true, format: Email::FORMAT,
                        length: { maximum: 64 }
    validates_uniqueness_of :address
  end

  class Update < Create
    validates :security_code, presence: true, unless: :blocked?
    validates_uniqueness_of :security_code

    def blocked?
      self.model.aasm_state == 'blocked'
    end
  end
end
