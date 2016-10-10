# frozen_string_literal: true
module API::V1
  module User
    class Index < API::V1::Default::Index
      # def model!(params)
      #   query = ::User
      #
      #   if params[:query]
      #     query.where('LOWER(display_name) LIKE LOWER(?)', "%#{params[:query]}%")
      #   else
      #     query.all
      #   end
      # end
      def base_query
        ::User
      end

      representer API::V1::User::Representer::Show
    end
  end
end
