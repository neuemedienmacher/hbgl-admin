module API::V1
  module Category
    class Sort < Trailblazer::Operation
      attr_reader :update_count
      def model
        ::Category
      end

      def process(params)
        category_tree = params[:categories]
        @update_count = 0
        iterate_category_tree_and_update_sort_order(category_tree)
      end

      private

      def iterate_category_tree_and_update_sort_order category_tree
        for sort_order, category_data in category_tree
          update_sort_order_if_necessary(category_data, sort_order)
        end
      end

      def update_sort_order_if_necessary category_data, sort_order
        found_category = model.select(:id, :sort_order).find(category_data[:id])
        # sort_order should be human readable - starting with 1 instead of 0
        desired_sort_order = sort_order.to_i + 1

        if found_category.sort_order != desired_sort_order
          found_category.update_column(:sort_order, desired_sort_order)
          @update_count = @update_count + 1
        end

        if category_data[:children]
          iterate_category_tree_and_update_sort_order(category_data[:children])
        end
      end
    end
  end
end
