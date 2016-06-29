# frozen_string_literal: true
module Backend::FormFields
  class TextareaCell < Cell::Concept
    def show
      render
    end

    private

    def form
      options[:f]
    end

    def field_name
      options[:field]
    end
  end
end
