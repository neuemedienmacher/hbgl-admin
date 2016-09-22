# frozen_string_literal: true
class ProductivityGoalsController < BackendController
  skip_before_action :verify_authenticity_token

  def index
  end

  def show
    present ProductivityGoal::Update
  end

  # def new
  #   form ProductivityGoal::Create
  # end
  #
  # def create
  #   run ProductivityGoal::Create do |op|
  #     flash[:success] = 'Ziel erfolgreich angelegt.'
  #     return redirect_to productivity_goal_path(op.model)
  #   end
  #   flash[:error] = @operation.errors.full_messages.join('. ')
  #   render :new
  # end
  #
  # def edit
  #   form ProductivityGoal::Update
  # end
  #
  # def update
  #   run ProductivityGoal::Update
  #   render :edit
  # end
end
