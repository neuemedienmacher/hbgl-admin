# frozen_string_literal: true
class ContactPersonObserver < ActiveRecord::Observer
  def after_create cont
    cont.generate_translations!
  end

  def after_commit cont
    fields = cont.changed_translatable_fields
    return true if fields.empty?
    cont.generate_translations! fields
  end
end
