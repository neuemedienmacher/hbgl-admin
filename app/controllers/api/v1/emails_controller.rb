# frozen_string_literal: true

module API::V1
  class EmailsController < API::V1::BackendController
    # sends ToS-Mailing via async worker
    def send_tos_mailing
      email = ::Email.find(params[:id])
      # TODO: only visible_in_frontend or offers.any?
      if email.tos == 'uninformed'
        if email.offers.any?
          # TosMailWorker.perform_async email.id
          TosMailWorker.new.perform email.id
          render json: {}, status: 200
        else
          render_error 'Mit der Email sind keine Angebote verknüpft!'
        end
      else
        render_error 'Es wurde bereits eine Mail verschickt!'
      end
    end

    private

    def render_error msg
      render json: { message: msg }, status: 403
    end
  end
end
