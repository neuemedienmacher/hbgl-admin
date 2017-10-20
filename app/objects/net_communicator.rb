# frozen_string_literal: true

require 'net/http'
require 'uri'

class NetCommunicator
  def initialize(base_uri)
    @uri = URI.parse(base_uri)
  end

  protected

  def post_to_api endpoint, form_hash
    request = Net::HTTP::Post.new(endpoint)
    request.set_form_data form_hash
    request = modify_request request
    send_request_to_api request
  end

  def send_request_to_api request
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.request(request)
  end

  # Overwritable
  def modify_request(request); request; end
end
