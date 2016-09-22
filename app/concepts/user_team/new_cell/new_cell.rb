# frozen_string_literal: true
class UserTeam::NewCell < Cell::Concept
  def show
    render
  end

  private

  include Cell::SimpleFormCell
  include Backend::FormFields::Methods

  def form &block
    simple_form_for(model, url: user_teams_path, &block)
  end
end
