module Backend::FormFields
  class StringCell < Cell::Concept
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
