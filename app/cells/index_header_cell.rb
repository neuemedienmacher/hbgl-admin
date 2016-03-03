class IndexHeaderCell < Cell::ViewModel
  property :name

  def show
    render
  end

  private

  def pluralized_name
    name.downcase.pluralize
  end

  def current_path
    request.fullpath
  end

  def current_search_input_value
    params[:search]
  end

  def self_referential_link
    link_to 'Liste', send("#{pluralized_name}_path")
  end

  def new_object_link
    link_to 'Neuet Teil', send("new_#{name.downcase}_path")
  end

  def export_link
    link_to 'Export', new_export_path(object_name: name.downcase)
  end
end
