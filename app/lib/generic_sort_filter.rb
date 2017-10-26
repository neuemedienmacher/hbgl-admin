# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
module GenericSortFilter
  def self.transform(base_query, params)
    adjusted_params = snake_case_contents(params)
    adjusted_params = fill_param_defaults(adjusted_params)
    query = ensure_query(base_query)
    query = transform_by_joining(query, adjusted_params)
    query = transform_by_ordering(query, adjusted_params)
    query = transform_by_searching(query, adjusted_params[:query])
    transform_by_filtering(query, adjusted_params)
  end

  private_class_method

  UNDERSCORABLE_PARAMS = %i[sort_field sort_model filters operators].freeze
  def self.snake_case_contents(params)
    new_hash = params.is_a?(Hash) ? params : params.to_unsafe_h
    new_hash.map do |string_key, value|
      key = string_key.to_sym
      if UNDERSCORABLE_PARAMS.include?(key)
        [key, snake_case_value(value)]
      else
        [key, value]
      end
    end.to_h
  end

  def self.snake_case_value(value)
    if value.is_a?(Hash)
      value.map { |k, v| [k.underscore, v] }.to_h
    elsif value.is_a?(Array)
      value.map(&:underscore)
    else
      value.underscore
    end
  end

  def self.fill_param_defaults(params)
    # TODO: handle models that don't have 'id' field
    params[:sort_field] = 'id' if !params[:sort_field] && !params[:query]
    params
  end

  # In case only a model was passed in, to unify object handling, turn it into
  # a query
  def self.ensure_query(query)
    query.where('1 = 1')
  end

  def self.transform_by_searching(query, param)
    if param.blank? || query.search_pg(param).nil?
      query
    else
      query.search_pg(param).extend(EnableEagerLoading)
    end
  end

  def self.transform_by_joining(query, params)
    query = transform_by_joining_sort_model(query, params)
    transform_by_joining_filter(query, params)
  end

  def self.transform_by_joining_sort_model(query, params)
    return query unless params[:sort_model]
    join! query, params[:sort_model].split('.')
  end

  def self.transform_by_joining_filter(query, params)
    params[:filters]&.each do |filter, _value|
      next unless filter['.']
      split_filter = filter.split('.')
      next if referring_to_own_table?(query, split_filter.first) # dont join self
      query = join! query, split_filter[0..-2] # [-1] is filtered attribute
    end
    query
  end

  def self.join!(query, associations)
    query.eager_load join_string_or_hash associations
  end

  def self.join_string_or_hash(request_array)
    if request_array.length > 1
      { request_array[0] => request_array[1] } # assuming depth of 2, can't yet handle more
    else
      request_array[0]
    end
  end

  def self.transform_by_ordering(query, params)
    return query unless params[:sort_field]
    sort_string = params[:sort_field]
    sort_model =
      if params[:sort_model]
        table_name_for(query, params[:sort_model])
      else
        query.model.name.pluralize.underscore
      end
    sort_string =
      "#{sort_model}.#{sort_string} #{params[:sort_direction] || 'DESC'}"
    query.order(sort_string)
  end

  def self.transform_by_filtering(query, params)
    return query unless params[:filters]
    params[:filters].each_with_index do |filter, index|
      value_or_values = filter[1]
      next if value_or_values.empty?

      query = range_or_singular_filter_query!(
        params, query, value_or_values, filter[0], index
      )
    end
    query
  end

  def self.range_or_singular_filter_query!(
    params, query, value_or_values, key, index
  )
    value =
      value_or_values.is_a?(Hash) ? value_or_values.values : value_or_values
    # convert value_or_values to array for streamlined processing
    value_array = (value.is_a?(Array) ? value : [value]).reject(&:blank?)

    if range_filter_query?(params, value_array)
      build_range_filter_query(query, params, key, value)
    else
      # build query strings to every array entry (only one for simple filters)
      filter_strings = value_array.map do |singular_value|
        build_singular_filter_query(query, params, key, singular_value)
      end
      filter!(query, filter_strings, params, key, index)
    end
  end

  def self.filter!(query, filter_strings, params, filter, index)
    where_method =
      if index.zero? || # first one whould always be 'where'
         !params[:operators] || params[:operators]['interconnect'] != 'OR'
        :where # AND method
      else
        :or
      end
    query.send where_method, filter_strings.join(join_operator(params, filter))
  end

  def self.range_filter_query?(params, values)
    !params[:operators].nil? && params[:operators].value?('...') &&
      values.count > 1
  end

  def self.join_operator(params, filter)
    if !params[:operators] || !params[:operators][filter] ||
       params[:operators][filter] == '='
      ' OR '
    else
      ' AND '
    end
  end

  def self.build_range_filter_query(query, params, filter, value)
    range = sort_range(value)
    filter_key = joined_or_own_table_name_for(query, filter, params)
    filter_string = filter_key.to_s
    query.where("#{filter_string} BETWEEN '#{range[0]}' AND '#{range[1]}'")
  end

  def self.sort_range(values)
    if values.first.respond_to?(:to_date)
      values.sort
    else
      values.sort_by(&:to_i)
    end
  end

  def self.build_singular_filter_query(query, params, filter, value)
    # transform table names (before a .) in case of association name mismatch
    filter_key = joined_or_own_table_name_for(query, filter, params)
    filter_string = filter_key.to_s
    operator = process_operator(params[:operators], filter, value)
    # append value
    new_value = transform_value(value, filter, query)
    filter_string = cast_if_needed(filter_string, operator, value, new_value)
    # append optional addition
    filter_string + optional_query_addition(operator, new_value, filter_key)
  end

  def self.cast_if_needed(filter_string, operator, value, new_value)
    if ['LIKE', 'NOT LIKE'].include?(operator)
      'CAST(' + filter_string + ' AS TEXT) ' + operator + " '%" + value + "%'"
    else
      filter_string + ' ' + operator + ' ' + new_value
    end
  end

  def self.joined_or_own_table_name_for(query, filter, params)
    if filter['.']
      split_filter = filter.split('.')
      table = table_name_for(query, split_filter[0..-2].join('.'))
      column = split_filter[-1]
      "#{table}.#{column}"
    elsif params[:controller]
      params[:controller].split('/').last + '.' + filter
    else
      filter
    end
  end

  def self.table_name_for(query, filter)
    return filter if referring_to_own_table?(query, filter)
    if filter.include?('.')
      path = filter.split('.') # once again, assuming depth of exactly 2
      base_association = association_for(query.model, path[0])
      association_for(base_association.klass, path[1]).table_name
    else
      association_for(query.model, filter).table_name
    end
  end

  def self.association_for(model, filter)
    model.reflections[filter]
  end

  # retrives the given operator or falls back to '='. Special case for 'nil'
  def self.process_operator(operators, filter, value)
    operator = operators && operators[filter] && operators[filter] != '...' ? operators[filter] : '='
    if nullable_value?(value)
      operator = operator == '=' ? 'IS' : 'IS NOT'
    end
    operator
  end

  def self.transform_value(value, filter, query)
    model, filter =
      if filter.include?('.')
        [model_for_filter(query, filter), filter.split('.').last]
      else
        [query.model, filter]
      end
    value = parse_value_by_type(value, filter, model)
    # NULL-filters are not allowed to stand within ''
    nullable_value?(value) ? 'NULL' : "'#{value}'"
  end

  def self.model_for_filter(query, filter)
    if referring_to_own_table?(query, filter.split('.').first)
      filter.split('.').first.classify.constantize
    else
      query.model.reflections[filter.split('.').first].table_name.classify
           .constantize
    end
  end

  def self.parse_value_by_type(value, filter, model)
    # convert (date)time strings to specific format for query
    column_data = model.columns_hash[filter]

    if column_data && !nullable_value?(value) && !value.empty?
      if column_data.type == :datetime
        return parse_datetime(value)
      end
    end
    value
  end

  def self.parse_datetime(value)
    # TODO: does this work in DST?
    Time.zone.parse(value).to_datetime.to_s
  end

  def self.optional_query_addition(operator, value, filter_key)
    # append OR NULL for non-null, NOT-queries (include optionals)
    if operator == '!=' && !nullable_value?(value)
      " OR #{filter_key} IS NULL"
    else
      ''
    end
  end

  def self.nullable_value?(value)
    value == 'nil' || value == 'null' || value == 'NULL'
  end

  def self.referring_to_own_table?(query, string)
    string.classify == query.model.name
  end
end
# rubocop:enable Metrics/ModuleLength
