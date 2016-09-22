# frozen_string_literal: true
class User::EditCell < Cell::Concept
  def show
    render
  end

  private

  include Cell::SimpleFormCell

  def form &block
    simple_form_for(model, url: user_path(model.model), method: 'PATCH', &block)
  end
end
