module API::V1
  module OrganizationTranslation
    class Show < Trailblazer::Operation
      include Model
      model ::OrganizationTranslation, :find

      include Trailblazer::Operation::Representer
      representer API::V1::OrganizationTranslation::Representer::Show

      def process(*)
      end
    end
  end
end
