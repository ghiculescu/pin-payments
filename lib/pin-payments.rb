require 'httparty'
require 'json'

require 'pin-payments/base'
require 'pin-payments/response'
require 'pin-payments/card'
require 'pin-payments/charge'
require 'pin-payments/customer'
require 'pin-payments/refund'

module Pin
  class Error < StandardError; end
  class APIError < Error
    attr_reader :code, :error, :description, :response
    
    def initialize(response)
      @code = response.code
      @error = response['error']
      @description = response['description']
      @response = response
    end
    
    def to_s
      "#@code #@error #@description"
    end
  end
  
  class << self
    attr_reader :publishable_key, :js_url, :auth

    def setup(options)
      raise ArgumentError, "Pin.setup wants an options hash" unless Hash === options
      raise ArgumentError, "no secret key configured" unless options[:secret_key]
      raise ArgumentError, "no mode configured" unless options[:mode]
    
      @auth = {username: options[:secret_key], password: ''}
      @publishable_key = options[:publishable_key]
    
      mode = options[:mode].to_sym
      uri = if mode == :live
        "https://api.pin.net.au"
      elsif mode == :test
        "https://test-api.pin.net.au"
      else
        raise ArgumentError, "Incorrect API mode! Must be :live or :test"
      end
    
      @js_url = "#{uri}/pin.js"
      Pin::Base.base_uri "#{uri}/1"
    end
  end
end
