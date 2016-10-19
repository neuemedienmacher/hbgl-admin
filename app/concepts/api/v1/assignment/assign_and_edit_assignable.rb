module API::V1
  module Assignment
    class AssignAndEditAssignable < Trailblazer::Operation
      include Model
      model ::Assignment, :find

      include Trailblazer::Operation::Representer
      representer API::V1::Assignment::Representer::Show

      include Trailblazer::Operation::Policy
      policy ::AssignmentPolicy, :assign_and_edit_assignable?

      def process(params)
        puts '==================model================='
        puts model.assignable_type
        puts model.assignable_id
        puts model.assignable
        puts '==================params================='
        puts params
      end
    end
  end
end
