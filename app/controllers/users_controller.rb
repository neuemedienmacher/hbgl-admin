# frozen_string_literal: true
class UsersController < BackendController
  def index
  end

  def edit
    form User::Update
  end

  def update
    run User::Update

    respond_to do |format|
      format.html { render :edit }
      format.json { render(json: {status: 'success'}) }
    end
  end
end
