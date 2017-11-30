# frozen_string_literal: true

class Division::Delete < Trailblazer::Operation
  step :find_model
  step Policy::Pundit(PermissivePolicy, :delete?)
  step :abort_with_connected_offers
  step :destroy!
  step ::Lib::Macros::Live::SendDeletion()

  def find_model(options, params:, model_class:, **)
    options['model'] = model_class.find(params[:id])
  end

  def destroy!(_, model:, **)
    model.destroy!
  end

  def abort_with_connected_offers(_, model:, **)
    model.offers.empty?
  end
end
