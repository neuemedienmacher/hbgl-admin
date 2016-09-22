# frozen_string_literal: true
class OrganizationTranslationsController < BackendController
  def index
    @klass = OrganizationTranslation.where(locale: [:ar, :en])
  end

  def edit
    form OrganizationTranslation::Update
  end

  def update
    run OrganizationTranslation::Update
    render :edit
  end
end
