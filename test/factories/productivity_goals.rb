# frozen_string_literal: true
FactoryGirl.define do
  factory :productivity_goal do
    title 'Factory Goal'
    starts_at { Date.current }
    ends_at { starts_at + 1.week }
    target_model { ProductivityGoal::TARGET_MODELS.sample }
    target_count { rand(10..100) }
    target_field_name do
      ProductivityGoal::TARGET_FIELD_NAMES[target_model].sample
    end
    target_field_value do
      ProductivityGoal::TARGET_FIELD_VALUES[target_model][target_field_name]
        .sample
    end
    user_team

    trait :running do
      starts_at { Date.current - 1.week }
      ends_at { Date.current + 1.week }
    end
  end
end
