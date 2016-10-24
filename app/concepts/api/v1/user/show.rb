module API::V1
  module User
    class Show < Trailblazer::Operation
      include Model
      model ::User, :find

      include Trailblazer::Operation::Representer
      representer API::V1::User::Representer::Show

      def process(*)
      end
    end
  end
end
