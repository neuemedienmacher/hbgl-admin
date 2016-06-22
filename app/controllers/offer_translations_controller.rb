# frozen_string_literal: true
class OfferTranslationsController < BackendController
  def edit
    form OfferTranslation::Update
  end

  def update
    run OfferTranslation::Update
    render :edit
  end
end
