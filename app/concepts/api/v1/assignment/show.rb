module API::V1
  module Assignment
    class Show < Trailblazer::Operation
      include Model
      model ::Assignment, :find

      include Trailblazer::Operation::Representer
      representer API::V1::Assignment::Representer::Show

      def process(*)
      end
    end
  end
end
