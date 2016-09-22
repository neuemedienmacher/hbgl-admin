module API::V1
  module Organization
    class Show < Trailblazer::Operation
      include Model
      model ::Organization, :find

      include Trailblazer::Operation::Representer
      representer API::V1::Organization::Representer::Show

      def process(*)
      end
    end
  end
end
