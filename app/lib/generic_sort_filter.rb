# frozen_string_literal: true
module GenericSortFilter
  def self.transform(base_query, params)
    query = ensure_query(base_query)
    query = transform_by_searching(query, params[:query])
    query = transform_by_joining(query, params)
    query = transform_by_ordering(query, params)
    transform_by_filtering(query, params[:filter], params[:operator])
  end

  private

  # In case only a model was passed in, to unify object handling, turn it into
  # a query
  def self.ensure_query(query)
    query.where('1 = 1')
  end

  def self.transform_by_searching(query, param)
    return query if !param || param.empty?
    query.search_everything(param)
  end

  def self.transform_by_joining(query, params)
    if (params[:sort_model])
      query = query.eager_load(params[:sort_model].split('.').first)
    end

    if (params[:filter])
      params[:filter].each do |filter, value|
        next unless filter['.']
        association_name = filter.split('.').first
        query = query.eager_load(association_name.to_sym)
      end
    end

    return query
  end

  def self.transform_by_ordering(query, params)
    return query unless params[:sort_field]
    sort_string = params[:sort_field]
    if params[:sort_model]
      association_name = table_name_for(query, params[:sort_model])
      sort_string = "#{association_name}.#{sort_string}"
    end
    sort_string += ' ' + (params[:sort_direction] || 'DESC')
    query.order(sort_string)
  end

  def self.transform_by_filtering(query, filters, operators)
    return query unless filters
    filters.each do |filter, value|
      next if value.empty?
      # transform table names (before a .) in case of association name mismatch
      filter_key = filter['.'] ? joined_table_name_for(query, filter) : filter
      filter_string = filter_key.to_s
      # append operator
      operator = process_operator(operators, filter, value)
      filter_string += ' ' + operator
      # append value
      _value = transform_value(value, filter, query)
      filter_string += ' ' + _value
      # append optional addition
      filter_string += optional_query_addition(operator, _value, filter_key)

      query = query.where(filter_string)
    end
    query
  end

  def self.joined_table_name_for(query, filter)
    split_filter = filter.split('.')
    split_filter[0] = table_name_for(query, split_filter[0])
    split_filter.join('.')
  end

  def self.table_name_for(query, filter)
    association_for(query, filter).table_name
  end

  def self.association_for(query, filter)
    query.model.reflections[filter]
  end

  # retrives the given operator or falls back to '='. Special case for 'nil'
  def self.process_operator(operators, filter, value)
    operator = operators && operators[filter] ? operators[filter] : '='
    if nullable_value?(value)
      operator = operator == '=' ? 'IS' : 'IS NOT'
    end
    operator
  end

  def self.transform_value(value, filter, query)
    model_name = filter.include?('.') ?
      filter.split('.').first.constantize : query.model
    # convert datetime strings to specific format for query
    if model_name.columns_hash[filter].type == :datetime && !value.empty?
      value = DateTime.parse(value + ' CET').utc.to_s
    end
    # NULL-filters are not allowed to stand within ''
    nullable_value?(value) ? 'NULL' : "'#{value}'"
  end

  def self.optional_query_addition(operator, value, filter_key)
    # append OR NULL for non-null, NOT-queries (include optionals)
    if operator == '!=' && nullable_value?(value)
      " OR #{filter_key} IS NULL"
    else
      ''
    end
  end

  def self.nullable_value?(value)
    value == 'nil' || value == 'null' || value == 'NULL'
  end
end
