# frozen_string_literal: true
# Non-Active-Record object to provide helper methods for exports
# TODO: This isn't actually a model. Put this somewhere else.
class Export
  BATCH_SIZE = 10
  attr_reader :object
  attr_writer :requested_fields

  def initialize object, object_query
    @object = object
    @object_query = object_query
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

  private

  # rubocop:disable Style/TrivialAccessors
  def object_query # TODO: joins for faster query & possibly search filter
    @object_query
  end
  # rubocop:enable Style/TrivialAccessors

  # If a field is not filled for a csv cell, give it a dash
  def dash_or string
    string.blank? ? ' - ' : string
  end

  def per_requested_field
    fields_to_process = @requested_fields.dup

    fields_to_process.delete(:model_fields).map do |field_name|
      yield :base, field_name
    end

    fields_to_process.each do |association_name, associated_fields_array|
      associated_fields_array.map do |associated_field_name|
        yield association_name, associated_field_name
      end
    end
  end

  def field_keys
    per_requested_field { |_carrier_name, field_name| field_name }
  end

  def row_headers
    header_array = []

    per_requested_field do |carrier_name, field_name|
      if carrier_name == :base
        header_array.push field_name
      else
        header_array.push "#{field_name} [#{carrier_name.to_s.titleize}]"
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

      values_array.push(
        value_for(object_instance.send(carrier_name), field)
      )
    end

    values_array
  end

  def value_for associated_object, field
    if associated_object.is_a?(ActiveRecord::Relation)
      dash_or associated_object.map { |element| element[field] }.join(',')
    elsif associated_object.nil?
      ' - '
    else
      dash_or associated_object[field]
    end
  end
end
