module API::V1
  module Default
    class Index < Trailblazer::Operation
      include Trailblazer::Operation::Representer

      def process(*)
      end
    end
  end
end
