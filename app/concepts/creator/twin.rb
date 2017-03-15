# frozen_string_literal: true
module Creator
  class Twin < Disposable::Twin
    property :created_by

    def creator
      User.find(created_by).name
    rescue
      'anonymous'
    end

    def current_actor
      ::PaperTrail.whodunnit
    end

    def different_actor?
      !created_by.nil? && !current_actor.nil? && created_by != current_actor
    end
  end
end
