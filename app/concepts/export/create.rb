# frozen_string_literal: true
# Prepares a non-ActiveRecord export object.
# Expects params like {model_fields: [:foo], users: [:name, :bar], comments: []}
class Export::Create < Trailblazer::Operation
  step :instantiate_model
  step Policy::Pundit(ExportPolicy, :create?)
  step :validate_and_sanitize_params
  step :set_requested_fields

  def instantiate_model(options, params:, **)
    object = params[:object_name].classify.constantize
    options['model'] =
      Export.new(
        object,
        GenericSortFilter.transform(object, params.except(:controller))
      )
  end

  def validate_and_sanitize_params(options, params:, model:, **)
    validate_model_fields(options, params, model) &&
      clean_empty_field_sets(options, params)
  end

  def validate_model_fields(options, params, model)
    # TODO: doesn't validate association keys
    forbidden_fields = params[:export][:model_fields] - model.allowed_fields
    if forbidden_fields.empty?
      true
    else
      options['result.message'] =
        "Forbidden fields provided: #{forbidden_fields}"
      false
    end
  end

  def clean_empty_field_sets(options, params)
    # clean params of empty array entries
    params[:export].reject! { |_key, value| value.empty? }
    options['params'] = params
    true
  end

  def set_requested_fields(options, params:, **)
    options['model'].requested_fields = params[:export]
  end
end
