# frozen_string_literal: true
FactoryGirl.define do
  factory :statistic do
    transient do
      goal nil
    end

    user do
      if goal
        goal.user_team.users.sample
      else
        FactoryGirl.create :researcher
      end
    end

    date do
      if goal
        goal.starts_at
      else
        Date.current
      end
    end

    count do
      max = goal ? goal.count : 99
      rand(1..max)
    end

    user_team do
      if goal
        goal.user_team
      else
        FactoryGirl.create :user_team, users: [user]
      end
    end

    model do
      goal ? goal.target_model : StatisticChart::TARGET_MODELS.sample
    end

    field_name do
      if goal
        goal.target_field_name
      else
        StatisticChart::TARGET_FIELD_NAMES[model].sample
      end
    end

    field_start_value do # TODO: booleans?
      if goal
        (StatisticChart::TARGET_FIELD_VALUES[model][field_name] -
          [goal.target_field_value]).sample
      else
        StatisticChart::TARGET_FIELD_VALUES[model][field_name].sample
      end
    end

    field_end_value do
      if goal
        goal.target_field_value
      else
        (StatisticChart::TARGET_FIELD_VALUES[model][field_name] -
          [field_start_value]).sample
      end
    end
  end
end
