class Export::Create < Trailblazer::Operation
  include Model
  model Export, :create

  def create_model(params)
    Export.new(params[:object_name].titleize.constantize)
  end

  contract do
    property :fields

    def allowed_fields
      model.column_names
    end

    validate do |form|
      forbidden_fields = (form.fields - allowed_fields)
      next if forbidden_fields.size == 0
      errors.add(:fields, "Forbidden fields provided: #{forbidden_fields}")
    end
  end

  def process(params)
    params[:export][:fields].reject!(&:empty?)

    validate(params[:export]) do |object|
      object.model.fields = params[:export][:fields]
    end
  end
end
