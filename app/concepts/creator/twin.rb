# frozen_string_literal: true

module Creator
  class Twin < Disposable::Twin
    property :created_by
    property :paper_trail

    def creator
      User.find(created_by).name
    rescue
      'anonymous'
    end

    def current_actor
      ::PaperTrail.whodunnit
    rescue
      !paper_trail.nil? ? paper_trail.originator : created_by
    end

    def different_actor?
      !created_by.nil? && !current_actor.nil? && created_by != current_actor
    end
  end
end
