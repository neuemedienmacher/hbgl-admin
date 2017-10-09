# frozen_string_literal: true

require 'httparty'
# simple class that includes HTTParty and uses a specific SSL cipher to avoid
# OpenSSL::SSL::SSLError
class HttpWithCipher
  include HTTParty
  ciphers 'DES-CBC3-SHA'
end
