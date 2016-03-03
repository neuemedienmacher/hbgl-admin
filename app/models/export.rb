# Non-Active-Record object to provide helper methods for exports
class Export
  BATCH_SIZE = 10.freeze
  attr_accessor :fields, :object

  def initialize object
    @object = object
  end

  def column_names
    object.column_names
  end

  def csv_header
    CSV::Row.new(@fields, @fields, true) # true - means its a header
  end

  def csv_row object_instance
    row_values = @fields.map { |field| object_instance[field] }
    CSV::Row.new(@fields, row_values)
  end

  def csv_lines
    @object.find_each(batch_size: BATCH_SIZE) do |object_instance|
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
end
