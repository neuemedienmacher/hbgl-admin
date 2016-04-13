class Statistics::ListCell < Cell::Concept
  def show
    render
  end

  private

  def linked_statistics
    [:offer_created, :offer_approved, :organization_created, :organization_approved]
  end

  def statistic_link(topic)
    path = statistic_path(topic: topic)
    link_to topic, path, class: "list-group-item #{active_class(path)}"
  end

  def active_class(path)
    'active' if path == request.fullpath
  end
end
