# frozen_string_literal: true
module GenericSortFilter
  def self.transform(base_query, params)
    query = base_query
    query = transform_by_searching(query, params[:query])
    query = transform_by_joining(query, params)
    query = transform_by_ordering(query, params)
    transform_by_filtering(query, params[:filter])
  end

  private

  def self.transform_by_searching(query, param)
    return query if !param || param.empty?
    query.search_everything(param)
  end

  def self.transform_by_joining(query, params)
    if (params[:sort_model])
      query = query.joins(params[:sort_model].to_sym)
    end
    return query
  end

  def self.transform_by_ordering(query, params)
    return query unless params[:sort_field]
    sort_string = params[:sort_field]
    if params[:sort_model]
      if params[:sort_klass]
        sort_string = "#{params[:sort_klass].pluralize}.#{sort_string}"
      else
        sort_string = "#{params[:sort_model].pluralize}.#{sort_string}"
      end
    end
    sort_string += ' ' + (params[:sort_direction] || 'DESC')
    query.order(sort_string)
  end

  def self.transform_by_filtering(query, filters)
    return query unless filters
    filters.each do |filter, value|
      next if value.empty?
      # allow for nil as string from JavaScript and convert it to ruby nil
      query = query.where(filter => value == 'nil' ? nil : value)
    end
    query
  end
end
