# frozen_string_literal: true

module Default
  class Delete < Trailblazer::Operation
    step :find_model
    step Policy::Pundit(PermissivePolicy, :delete?)
    step :destroy!, name: 'destroy_record'
    step ::Lib::Macros::Live::SendDeletion()

    def find_model(options, params:, model_class:, **)
      options['model'] = model_class.find(params[:id])
    end

    def destroy!(_, model:, **)
      model.destroy!
    end
  end
end
