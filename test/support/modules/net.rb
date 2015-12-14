module Net
  class HTTP
    cattr_accessor :test_enabled

    def request *attrs
      if self.class.test_enabled
        super
      else
        'stubbed'
      end
    end
  end
end
