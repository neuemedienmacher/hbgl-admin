class Assignment::Update < Trailblazer::Operation
  step Model(::Assignment, :find_by)

  step Policy::Pundit(::AssignmentPolicy, :update?)

  step Contract::Build()
  step Contract::Validate()
  step Contract::Persist()

  extend Contract::DSL
  contract do
    property :assignable_id
    property :assignable_type
    property :creator_id
    property :creator_team_id
    property :receiver_id
    property :receiver_team_id
    property :message
    property :aasm_state

    validates :receiver_id, numericality: true, allow_blank: true
  end

  # def side_effects!(item)
  #   puts '==========side_effects=========='
  #   puts item.aasm_state
  #   system_user = ::User.find_by(name: 'System')
  #   current_user = ::User.find(item.receiver_id)
  #   puts system_user
  #   ::Assignment.create!(
  #     assignable_id: item.assignable_id,
  #     assignable_type: item.assignable_type,
  #     creator_id: system_user.id,
  #     receiver_id: system_user.id,
  #     message: 'System self-assigned this, because ' + current_user.name + ' closed the active Assignment.'
  #   )
  # end
end
