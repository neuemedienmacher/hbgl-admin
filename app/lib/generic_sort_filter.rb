# frozen_string_literal: true
module GenericSortFilter
  def self.transform(base_query, params)
    query = ensure_query(base_query)
    query = transform_by_searching(query, params[:query])
    query = transform_by_joining(query, params)
    query = transform_by_ordering(query, params)
    transform_by_filtering(query, params[:filter])
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
      association_name =
        table_name_for(query, params[:sort_model].split('.').first)
      query = query.joins(association_name.to_sym)
    end

    if (params[:filter])
      params[:filter].each do |filter, value|
        next unless filter['.']
        association_name = filter.split('.').first
        query = query.joins(association_name.to_sym)
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

  def self.transform_by_filtering(query, filters)
    return query unless filters
    filters.each do |filter, value|
      next if value.empty?
      # allow for nil as string from JavaScript and convert it to ruby nil
      processed_value = value == 'nil' ? nil : value
      # transform table names (before a .) in case of association name mismatch
      filter_key = filter['.'] ? joined_table_name_for(query, filter) : filter
      query = query.where(filter_key => processed_value)
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
end
