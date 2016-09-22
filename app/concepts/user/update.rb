# frozen_string_literal: true
class User::Update < Trailblazer::Operation
  include Model
  model User, :update

  include Trailblazer::Operation::Policy
  policy UserPolicy, :update?

  contract do
    property :name
    property :email
    property :password#, virtual: true
    property :current_team_id

    validates :name, presence: true, allow_blank: true
    validates :email, presence: true, allow_blank: true

    validates :current_team_id, presence: true, allow_blank: true,
                                numericality: true
  end

  def process(params)
    validate(params[:user]) do |form_object|
      form_object.save
    end
  end
end
