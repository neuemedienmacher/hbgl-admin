# frozen_string_literal: true
class UserTeam < ActiveRecord::Base
  class GeneralContract < Reform::Form
    property :name
    property :user_ids

    validates :name, presence: true
    validates :user_ids, presence: true
  end

  class Create < Trailblazer::Operation
    step Model(::UserTeam, :new)
    step Policy::Pundit(::UserTeamPolicy, :create?)

    step Contract::Build( constant: UserTeam::GeneralContract )
    step Contract::Validate()
    step Contract::Persist()
  end

  class Update < Trailblazer::Operation
    step Model(::UserTeam, :find_by)
    step Policy::Pundit(::UserTeamPolicy, :update?)

    step Contract::Build( constant: UserTeam::GeneralContract )
    step Contract::Validate()
    step Contract::Persist()
  end
end
