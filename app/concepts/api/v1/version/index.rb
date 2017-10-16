# frozen_string_literal: true

module API::V1
  module Version
    class Index < API::V1::Default::Index
      def find_result_set(options, params:, **)
        query = ::PaperTrail::Version.where(
          item_id: params[:item_id], item_type: params[:item_type].classify
        ).order(:created_at)
        options['collection'] =
          query.paginate(page: params[:page], per_page: params[:per_page])
      end
    end
  end
end
