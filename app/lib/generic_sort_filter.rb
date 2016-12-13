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
      operator = process_operator(operators, filter, value)
      # append OR NULL for non-null, NOT-queries (include optionals)
      opt_appendix = operator == '!=' && nullable_value?(value) ?
        "OR #{filter_key} IS NULL" : ''
      # NULL-filters are not allowed to stand within ''
      _value = nullable_value?(value) ? 'NULL' : "'#{value}'"
      # build variable query (filtering with variable operators)
      query = query.where("#{filter_key} #{operator} #{_value} #{opt_appendix}")
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

  def self.nullable_value?(value)
    value == 'nil' || value == 'null' || value == 'NULL'
  end
end
