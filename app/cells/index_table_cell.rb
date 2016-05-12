# frozen_string_literal: true
# module IndexTable
#   class FrameworkCell < Cell::ViewModel
#     def show
#       render :framework
#     end
#
#     protected
#
#     def settings
#       @options[:settings]
#     end
#
#     def list_settings
#       settings['list']
#     end
#
#     private
#
#     def rows
#       cell 'index_table/row', {collection: index_objects}, @options
#     end
#
#     PER_PAGE = 20
#
#     def index_objects
#       objects = model
#         .limit(PER_PAGE)
#         .offset(current_page * PER_PAGE)
#         .order(current_order)
#       objects = search_modify(objects) if params[:search]
#       objects
#     end
#
#     def current_page
#       params[:page] ? (params[:page].to_i - 1) : 0
#     end
#
#     def current_order
#       params[:sort] ? "#{params[:sort]} ASC" : list_settings['order']
#     end
#
#     def search_modify objects
#       objects.where('name LIKE ?', "%#{params[:search]}%")
#     end
#
#     def last_page
#       1 # TODO: dynamic! && pagination separated && IndexTable Module and split this into different files
#     end
#
#     def pagination_needed?
#       last_page > 0
#     end
#
#     def page_link(humanized_page_number, anchor, link_class = nil)
#       if humanized_page_number >= 1 && humanized_page_number <= (last_page + 1)
#         link_to anchor, {page: humanized_page_number}, class: link_class
#       else
#         link_to anchor, 'javascript:;', class: link_class
#       end
#     end
#
#     def page_href(humanized_page_number)
#
#     end
#
#     def previous_disabled_class
#       'disabled' if current_page == 0
#     end
#
#     def page_active_class(humanized_page_number)
#       'active' if humanized_page_number == (current_page + 1)
#     end
#
#     def next_disabled_class
#       'disabled' if current_page == last_page
#     end
#   end
#
#   # ---------- SUBCELLS ---------- #
#
#   class RowCell < FrameworkCell
#     include ActionView::Helpers::UrlHelper
#
#     def show
#       render :row
#     end
#
#     private
#
#     def columns
#       list_settings['fields'].map do |field|
#         '<td>' + data_content(field) + '</td>'
#       end.join
#     end
#
#     def data_content(field)
#       cell('index_table/column', model.send(field), @options).()
#         .truncate(40)
#     end
#
#     def edit_link(&block)
#       link_to edit_offer_path(model), &block
#     end
#   end
#
#   class ColumnCell < FrameworkCell
#     builds do |model, options|
#       # Switch between different ways of displaying the cell content
#       case model
#       when String, Integer, NilClass
#         ColumnCell
#       when TrueClass, FalseClass
#         BooleanColumnCell
#       when ActiveRecord::Associations::CollectionProxy
#         CollectionColumnCell
#       else
#         AssociationColumnCell
#       end
#     end
#
#     def show # this handles the column content being simply renderable
#       model
#     end
#   end
#
#   class BooleanColumnCell < FrameworkCell
#     def show
#       render :boolean_column
#     end
#
#     def active?
#       model
#     end
#   end
#
#   class CollectionColumnCell < FrameworkCell
#     def show
#       model.map do |element|
#         cell('index_table/association_column', element)
#       end.join(', ')
#     end
#   end
#
#   class AssociationColumnCell < FrameworkCell
#     def show
#       model.try(:display_name) || model.try(:name) ||
#         raise("#{model} needs display_name")
#     end
#   end
# end
