# frozen_string_literal: true
class Backend::IndexHeaderCell < Cell::Concept
  property :name

  def show
    render
  end

  private

  def singular_name
    name.tableize.singularize
  end

  def pluralized_name
    name.tableize.pluralize
  end

  def current_path
    request.fullpath
  end

  def current_search_input_value
    params[:search]
  end

  def header_links
    options[:header_links] || [:new, :export]
  end

  def header_link_paths
    link_array = [self_referential_link]
    header_links.each do |link|
      begin
        path = send("#{link}_link")
      rescue NoMethodError
        path = { path: send("#{link}_path"), anchor: link.to_s.titleize }
      end
      link_array.push path
    end
    link_array
  end

  def header_link link
    link_to link[:anchor], link[:path]
  end

  def self_referential_link
    { path: send("#{pluralized_name}_path"), anchor: 'Liste' }
  end

  def new_link
    { path: send("new_#{singular_name}_path"), anchor: 'Neu Anlegen' }
  end

  def export_link
    { path: new_export_path(object_name: name.underscore), anchor: 'Export' }
  end

  def active_class link
    'active' if link[:path] == current_path
  end
end
