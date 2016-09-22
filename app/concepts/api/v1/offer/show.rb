module API::V1
  module Offer
    class Show < Trailblazer::Operation
      include Model
      model ::Offer, :find

      include Trailblazer::Operation::Representer
      representer API::V1::Offer::Representer::Show

      def process(params)
        true
      end
    end
  end
end
