# Non-Active-Record object to provide helper methods for exports
class Export
  BATCH_SIZE = 10.freeze
  attr_reader :object
  attr_writer :requested_fields

  def initialize object
    @object = object
  end

  def allowed_fields
    object.column_names
  end

  def csv_header
    CSV::Row.new(field_keys, row_headers, true)
    # true - means it's a header
  end

  def csv_row object_instance
    CSV::Row.new(field_keys, row_values(object_instance))
  end

  def csv_lines
    object_query.find_each(batch_size: BATCH_SIZE) do |object_instance|
      yield object_instance
    end
  end

  ### --- Methods required for form generation: --- ###

  def persisted?
    false # not a database model
  end

  def has_attribute? name
    name == :fields
  end

  def column_for_attribute name
    nil
  end

  def to_key
    nil
  end

  private

  def object_query # TODO: joins for faster query & possibly search filter
    @object
    # @requested_fields.keys.each { |key| .joins(key) }
  end

  # If a field is not filled for a csv cell, give it a dash
  def dash_or string
    string.blank? ? ' - ' : string
  end

  def per_requested_field
    fields_to_process = @requested_fields.dup

    fields_to_process.delete(:model_fields).map do |field_name|
      yield :base, field_name
    end

    for association_name, associated_fields_array in fields_to_process
      associated_fields_array.map do |associated_field_name|
        yield association_name, associated_field_name
      end
    end
  end

  def field_keys
    per_requested_field { |carrier_name, field_name| field_name }
  end

  def row_headers
    header_array = []

    per_requested_field do |carrier_name, field_name|
      if carrier_name == :base
        header_array.push field_name
      else
        header_array.push "#{field_name} [#{carrier_name.titleize}]"
      end
    end

    header_array
  end

  def row_values object_instance
    values_array = []

    per_requested_field do |carrier_name, field|
      if carrier_name == :base
        values_array.push(object_instance[field])
        next
      end

      associated_object = object_instance.send(carrier_name)
      values_array.push(
        if associated_object.is_a?(ActiveRecord::Relation)
          dash_or associated_object.map { |element| element[field] }.join(',')
        elsif associated_object.nil?
          ' - '
        else
          dash_or associated_object[field]
        end
      )
    end

    values_array
  end
end
