# frozen_string_literal: true
class Backend::SidebarCell < Cell::Concept
  def show
    render
  end

  private

  def models
    AdminConfig.included_models
  end

  def model_link(linked_model)
    link_to linked_model, send("#{linked_model.tableize.pluralize}_path")
  end
end
