# frozen_string_literal: true
class UserTeam < ActiveRecord::Base
  class GeneralContract < Reform::Form
    property :name
    property :users
    property :observing_users

    validates :name, presence: true
    validates :users, presence: true
  end

  class Create < Trailblazer::Operation
    step Model(::UserTeam, :new)
    step Policy::Pundit(::UserTeamPolicy, :create?)

    step Contract::Build(constant: UserTeam::GeneralContract)
    step Contract::Validate()
    step Contract::Persist()
  end

  class Update < Trailblazer::Operation
    step Model(::UserTeam, :find_by)
    step Policy::Pundit(::UserTeamPolicy, :update?)

    step Contract::Build(constant: UserTeam::GeneralContract)
    step Contract::Validate()
    step Contract::Persist()
    step :update_team_statistic_on_user_change

    def update_team_statistic_on_user_change options
      if options['contract.default'].changed?('users')
        Statistic::DailyTeamStatisticSynchronizer.new(
          options['contract.default'].model.id, Time.zone.now.year
        ).record!
      end
      true
    end
  end
end
