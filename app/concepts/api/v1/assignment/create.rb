module API::V1
  module Assignment
    class Create < Trailblazer::Operation
      include Model
      model ::Assignment, :create

      include Trailblazer::Operation::Representer, Responder
      representer API::V1::Assignment::Representer::Show

      # TODO: more complex policy!
      include Trailblazer::Operation::Policy
      policy ::AssignmentPolicy, :create?

      contract do
        property :assignable_id
        property :assignable_type
        property :assignable_field_type
        property :creator_id
        property :creator_team_id
        property :reciever_id
        property :reciever_team_id
        property :message
        property :parent_id
        property :aasm_state
        property :created_at
        property :updated_at

        # TODO: check if model instance exists!! here or somewhere else?!
        validates :assignable_id, presence: true, numericality: true
        validates :assignable_type, presence: true
        # validates :assignable_field_type, presence: true # TODO: force empty string?!
        # uniqueness validation: make sure there is only one open assignment
        # w/o a parent (base assignment) per assignable model & field
        validates_uniqueness_of :assignable_id, scope: [:assignable_type, :assignable_field_type], conditions: -> { where(aasm_state: 'open').where(parent_id: nil) }
        validates_uniqueness_of :assignable_type, scope: [:assignable_id, :assignable_field_type], conditions: -> { where(aasm_state: 'open').where(parent_id: nil) }
        validates_uniqueness_of :assignable_field_type, scope: [:assignable_type, :assignable_id], conditions: -> { where(aasm_state: 'open').where(parent_id: nil) }
        # creator or creator_team must be present
        validates :creator_id, presence: true, unless: :creator_team_id
        validates :creator_team_id, presence: true, unless: :creator_id
        # reciever or reciever_team must be present
        validates :reciever_id, presence: true, unless: :reciever_team_id
        validates :reciever_team_id, presence: true, unless: :reciever_id
      end

      def process(params)
        if validate(params[:json])
          contract.save
        else
          raise "Assignment form has errors: #{contract.errors.full_messages}"
        end
      end
    end
  end
end
