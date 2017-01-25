module Assignable
  class Twin < Disposable::Twin
    collection :assignments

    # Methods
    # def field_assignments
    #   assignments.field
    # end

    # the current assignment must be active (open), a root assignment (no
    # parent) and it must belong to the model (and not to a field of the model).
    # There must always be exactly one current_assignment for each assignable.
    def current_assignment
      assignments.active.root.base.first
    end

    def current_field_assignment field
      # return nil if the required field is not existing on the assignable model
      return nil unless respond_to?(field)
      # return open field assignment if one exists or current model assignment
      assignments.active.root.where(assignable_field_type: field).first ||
        current_assignment
    end

    # closes the current assignment (if one exists) and creates a new one
    def create_new_assignment!(*args)
      create_new_assignment(*args)
      save
    end

    # def create_new_assignment(
    #   creator_id, creator_team_id, receiver_id, receiver_team_id, message = ''
    # )
    #   current_assignment.close! if current_assignment
    #   assignments << Assignment.new(
    #     assignable: model,
    #     assignable_type: model.class.name,
    #     creator_id: creator_id,
    #     creator_team_id: creator_team_id,
    #     receiver_id: receiver_id,
    #     receiver_team_id: receiver_team_id,
    #     message: message
    #   )
    #   self
    # end

    # TODO: Sub-Assignments (assignment with parent)
  end
end
