module API::V1
  module UserTeam
    class Show < Trailblazer::Operation
      include Model
      model ::UserTeam, :find

      include Trailblazer::Operation::Representer
      representer API::V1::UserTeam::Representer::Show

      def process(*)
      end
    end
  end
end
