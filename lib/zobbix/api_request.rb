require 'httparty'
require 'json'
require 'zobbix/api_response'

class Zobbix
  class ApiRequest
    include HTTParty

    headers 'Content-Type' => 'application/json-rpc'

    def self.default_params
      { 'jsonrpc' => '2.0' }
    end

    def self.path
      '/api_jsonrpc.php'
    end

    def self.perform(*args)
      new(*args).perform
    end

    # @param [String] uri Zabbix Server uri
    # @param [String] method API method
    # @param [Hash] params API method params
    def initialize(uri, method, params)
      @uri    = uri.sub(/\/$/, '')
      @method = method
      @auth   = params.delete(:auth)
      @params = params
    end

    # Execute http request
    #
    # @return [Zobbix::ApiResponse]
    def perform
      ApiResponse.new { self.class.post("#{@uri}#{self.class.path}", body: payload) }
    end

    private

    def id
      rand(9999) # Id should be totally random
    end

    def payload
      JSON.generate(self.class.default_params.merge(method: @method,
                                                    params: @params,
                                                    auth: @auth,
                                                    id: id))
    end
  end
end
