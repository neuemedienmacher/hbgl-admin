# frozen_string_literal: true

module Lib
  class Transaction
    extend Uber::Callable

    def self.call(_options, *)
      pipe, _result = ActiveRecord::Base.transaction { yield }
      pipe
    end
  end
end
