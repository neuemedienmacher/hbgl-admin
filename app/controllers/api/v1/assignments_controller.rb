# frozen_string_literal: true
module API::V1
  class AssignmentsController < API::V1::BackendController
    skip_before_action :authenticate_user!
    respond_to :json
  end
end
