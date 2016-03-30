module API::V1
  module Category
    class Sort < Trailblazer::Operation
      attr_reader :update_count
      def model!(params)
        ::Category
      end

      def process(params)
        category_tree = params[:categories]
        @update_count = 0
        iterate_category_tree_and_update_order(category_tree, nil)
      end

      private

      def iterate_category_tree_and_update_order category_tree, parent_id
        for sort_order, category_data in category_tree
          update_order_if_necessary(category_data, sort_order, parent_id)
        end
      end

      def update_order_if_necessary category_data, sort_order, parent_id
        found_category =
          model.select(:id, :sort_order, :parent_id).find(category_data[:id])
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
          @update_count = @update_count + 1
        end

        # recursion for all children
        if category_data[:children]
          iterate_category_tree_and_update_order(
            category_data[:children], category_data[:id]
          )
        end
      end
    end
  end
end
