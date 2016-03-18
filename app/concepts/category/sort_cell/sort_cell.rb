class Category::SortCell < Cell::Concept
  def show
    render :sort_cell
  end

  private

  def root_categories
    Category.mains
  end
end

class Category::TreeBranch < Category::SortCell
  def show
    render :tree_branch
  end

  private

  property :name

  def child_categories?
    child_categories.any?
  end

  def child_categories
    model.children
  end

  def item_data
    {id: model.id}
  end
end
