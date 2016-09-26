# frozen_string_literal: true
module GenericSortFilter
  def self.transform(base_query, params)
    query = base_query
    query = transform_by_searching(query, params[:query])
    query = transform_by_sorting(query, params)
    transform_by_filtering(query, params[:filter])
  end

  private

  def self.transform_by_searching(query, param)
    return query if !param || param.empty?
    query.search_everything(param)
  end

  def self.transform_by_sorting(query, params)
    return query unless params[:sort]
    query.order(params[:sort] => params[:direction] || 'DESC')
  end

  def self.transform_by_filtering(query, filters)
    return query unless filters
    filters.each do |filter, value|
      next if value.empty?
      query = query.where(filter => value)
    end
    query
  end
end
