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
    validate :hack_and_back
    def hack_and_back
      model.valid?
    end
  end
end
