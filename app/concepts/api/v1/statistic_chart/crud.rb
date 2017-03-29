# frozen_string_literal: true
module API::V1
  module StatisticChart
    class Create < ::StatisticChart::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::StatisticChart::Representer::Show
    end

    class Update < ::StatisticChart::Update
    end
  end
end
