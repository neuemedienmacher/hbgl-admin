module API::V1
  module Division
    class Show < Trailblazer::Operation
      include Model
      model ::Division, :find

      include Trailblazer::Operation::Representer
      representer API::V1::Division::Representer::Show

      def process(*)
      end
    end
  end
end
