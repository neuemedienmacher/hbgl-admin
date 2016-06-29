# frozen_string_literal: true
module API::V1
  class UsersController < ApplicationController
    skip_before_action :authenticate_user!
    respond_to :json

    def index
      respond API::V1::User::Index
    end
  end
end
