module API::V1
  module OfferTranslation
    class Show < Trailblazer::Operation
      include Model
      model ::OfferTranslation, :find

      include Trailblazer::Operation::Representer
      representer API::V1::OfferTranslation::Representer::Show

      def process(*)
      end
    end
  end
end
