# frozen_string_literal: true

require_relative '../test_helper'

describe Website do
  let(:website) do
    Website.new(host: 'own', url: 'http://www.clarat.org/example')
  end

  # Methods
  describe '#ascii_url' do
    it 'should work for a simple url' do
      website.ascii_url.must_equal 'http://www.clarat.org/example'
    end

    it 'should work for a host-only url' do
      website.url = 'http://www.awo-südost.de'
      website.ascii_url.must_equal 'http://www.xn--awo-sdost-u9a.de'
    end

    it 'should work for a already converted url' do
      website.url = 'http://www.xn--awo-sdost-u9a.de/familienberatung-kontakt'
      website.ascii_url.must_equal 'http://www.xn--awo-sdost-u9a.de/familienberatung-kontakt'
    end

    it 'should only change the host and ignore the path' do
      website.url = 'http://www.awo-südost.de/familienberatung-kontakt'
      website.ascii_url.must_equal 'http://www.xn--awo-sdost-u9a.de/familienberatung-kontakt'
    end
  end
end
