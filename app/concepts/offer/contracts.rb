# frozen_string_literal: true
module Offer::Contracts
  class Create < Reform::Form
    # fill me!
  end

  class Update < Create
    # fill me!
  end

  class ChangeState < Update
    # replace this with something useful
    delegate :valid?, to: :model, prefix: false
    delegate :errors, to: :model, prefix: false
  end
end
