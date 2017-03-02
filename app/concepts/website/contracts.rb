# frozen_string_literal: true
module Website::Contracts
  class Create < Reform::Form
    property :host
    property :url

    # binding.pry
    # validation do
    #   required(:host).filled
    # end

    # validates :host, presence: true
    # validates :url, format: %r{\Ahttps?://\S+\.\S+\z}, unique: true,
    #                 presence: true
    # validates :unreachable_count, presence: true
  end
end
