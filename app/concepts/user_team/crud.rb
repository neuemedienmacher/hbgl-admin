# frozen_string_literal: true
class UserTeam < ActiveRecord::Base
  class BaseOperation < Trailblazer::Operation
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()

    extend Contract::DSL
    contract do
      property :name
      property :user_ids

      validates :name, presence: true
      validates :user_ids, presence: true
    end
  end

  class Create < Trailblazer::Operation
    step Model(::UserTeam, :new)
    step Policy::Pundit(::UserTeamPolicy, :create?)
    step Nested(UserTeam::BaseOperation)
  end

  class Update < Trailblazer::Operation
    step Model(::UserTeam, :find_by)
    step Policy::Pundit(::UserTeamPolicy, :update?)
    step Nested(UserTeam::BaseOperation)
  end
end
