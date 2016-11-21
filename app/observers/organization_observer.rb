class OrganizationObserver < ActiveRecord::Observer
  def after_create orga
    orga.generate_translations!
  end

  def after_update orga
    fields = orga.changed_translatable_fields
    return true if fields.empty?
    orga.generate_translations! fields
  end

  def before_create orga
    return if orga.created_by
    current_user = ::PaperTrail.whodunnit
    orga.created_by = current_user if current_user.is_a? Integer # so unclean
  end
end
