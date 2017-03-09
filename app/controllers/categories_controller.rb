# frozen_string_literal: true
class CategoriesController < ApplicationController
  respond_to :json

  # Non-REST
  # TODO: extract into separate controller?

  def sort; end

  def mindmap; end

  # # For admin backend: Provides a list of categories that offers with name X
  # # already belong to.
  def suggest_categories
    offer_categories = Offer.where(name: params[:offer_name])
                            .joins(:categories).pluck('DISTINCT(categories.name_de)')

    respond_with offer_categories
  end
end
