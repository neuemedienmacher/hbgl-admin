# frozen_string_literal: true
class OfferTranslationsController < BackendController
  def index
    @klass = OfferTranslation.where(locale: [:ar, :ru, :en])
  end

  def edit
    form OfferTranslation::Update
  end

  def update
    run OfferTranslation::Update
    render :edit
  end
end
