# frozen_string_literal: true
module API::V1
  module Category
    class Sort < Trailblazer::Operation
      step :reset_initial_update_count_to_zero
      step :start_recursive_category_update

      def reset_initial_update_count_to_zero(options)
        options['update_count'] = 0
      end

      def start_recursive_category_update(options, params:, **)
        iterate_tree_and_update_order!(
          options, params[:categories], nil
        )
        true
      end

      ### --- The Magic: --- ##

      def iterate_tree_and_update_order! opts, category_tree, parent_id
        category_tree.each do |sort_order, category_data|
          update_order_if_necessary(opts, category_data, sort_order, parent_id)
        end
      end

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def update_order_if_necessary opts, category_data, sort_order, parent_id
        found_category = ::Category.select(:id, :sort_order, :parent_id)
                                   .find(category_data[:id])
        # sort_order should be human readable - starting with 1 instead of 0
        desired_sort_order = sort_order.to_i + 1
        was_updated = false

        if found_category.sort_order != desired_sort_order
          found_category.update_column(:sort_order, desired_sort_order)
          was_updated = true
        end

        if found_category.parent_id.to_s != parent_id.to_s
          found_category.update_column(:parent_id, parent_id)
          was_updated = true
        end

        if was_updated
          opts['update_count'] += 1
        end

        # recursion for all children
        if category_data[:children]
          iterate_tree_and_update_order!(
            opts, category_data[:children], category_data[:id]
          )
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
    end
  end
end
