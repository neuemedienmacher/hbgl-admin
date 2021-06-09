module API::V1
  module City
    class Update < ::City::Update
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::City::Representer::Update
    end
  end
end
