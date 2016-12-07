module API::V1
  module Assignment
    class Update < Trailblazer::Operation
      include Model
      model ::Assignment, :update

      include Trailblazer::Operation::Policy
      policy ::AssignmentPolicy, :update?

      include Trailblazer::Operation::Representer
      representer API::V1::Assignment::Representer::Show

      contract do
        property :assignable_id
        property :assignable_type
        property :creator_id
        property :creator_team_id
        property :reciever_id
        property :reciever_team_id
        property :message
        property :aasm_state

        validates :reciever_id, numericality: true, allow_blank: true
      end

      def process(params)
        validate(params[:json]) do |item|
          item.save
          # create a new Assignment to system when the current one is closed
          # side_effects!(item) if item.aasm_state == 'closed'
        end
        #   raise "Error while updating Assignment! #{contract.errors.full_messages}"
        # end
      end

      # def side_effects!(item)
      #   puts '==========side_effects=========='
      #   puts item.aasm_state
      #   system_user = ::User.find_by(name: 'System')
      #   current_user = ::User.find(item.reciever_id)
      #   puts system_user
      #   ::Assignment.create!(
      #     assignable_id: item.assignable_id,
      #     assignable_type: item.assignable_type,
      #     creator_id: system_user.id,
      #     reciever_id: system_user.id,
      #     message: 'System self-assigned this, because ' + current_user.name + ' closed the active Assignment.'
      #   )
      # end
    end
  end
end
