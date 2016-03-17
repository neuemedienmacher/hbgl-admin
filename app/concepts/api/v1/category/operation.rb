module API::V1
  module Category
    class Index < Trailblazer::Operation
      include Model
      model Category, :mains
      def mains_model(params)
        ::Category.mains
      end

      include Trailblazer::Operation::Representer
      representer API::V1::Category::Representer::Index

      def process(*)
      end
    end
  end
end
