class OfferObserver < ActiveRecord::Observer
  def after_initialize offer
    if offer.new_record?
      offer.expires_at ||= (Time.zone.now + 1.year)
      offer.logic_version_id = LogicVersion.last.id
    end
  end

  def after_create offer
    offer.generate_translations!
  end

  def after_update offer
    fields = offer.changed_translatable_fields
    return true if fields.empty?
    offer.generate_translations! fields
  end

  def before_create offer
    return if offer.created_by
    current_user = ::PaperTrail.whodunnit
    offer.created_by = current_user if current_user.is_a? Integer # so unclean
  end
end
