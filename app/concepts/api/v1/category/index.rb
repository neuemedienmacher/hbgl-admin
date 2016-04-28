module API::V1
  module Category
    class Index < API::V1::Default::Index
      def model!(params)
        ::Category.mains
      end

      representer API::V1::Category::Representer::Index
    end
  end
end
