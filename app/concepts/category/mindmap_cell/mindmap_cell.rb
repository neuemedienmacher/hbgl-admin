# frozen_string_literal: true
class Category::MindmapCell < Cell::Concept
  def show
    render
  end

  private

  def category_json
    concept('category/json_structure_cell')
  end
end
