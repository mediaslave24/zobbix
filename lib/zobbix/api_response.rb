class Zobbix
  class ApiResponse
    attr_reader :response, :exception

    def initialize(&request)
      @response = {}
      @exception = nil

      @response = request.call
    rescue => ex
      @exception = ex
    end

    # @return [Boolean] True, if no HTTP or API errors happened
    def success?
      @exception.nil? && @response['error'].nil?
    end

    # @return [Boolean] Opposite of #success?
    def error?
      !success?
    end

    # @return [String, Hash] API result. Depends on API method
    def result
      @response['result']
    end

    # @return [Fixnum, nil] Zabbix API error code
    def error_code
      @response['error'] && @response['error']['code']
    end

    # @return [String, nil] Zabbix API error message
    def error_message
      @response['error'] && @response['error']['message']
    end

    # @return [String, nil] Zabbix API error description
    def error_data
      @response['error'] && @response['error']['data']
    end

    # @return [Fixnum] Request id
    def id
      @response['id']
    end

    def raise_exception
      return if success?

      if @exception
        raise @exception
      else
        raise Error.new("API returned error. Code: #{error_code} Message: #{error_message} Data: #{error_data}")
      end
    end
  end
end
