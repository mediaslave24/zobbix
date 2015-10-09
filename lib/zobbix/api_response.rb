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

    def success?
      @exception.nil? && @response['error'].nil?
    end

    def error?
      !success?
    end

    def result
      @response['result']
    end

    def error_code
      @response['error'] && @response['error']['code']
    end

    def error_message
      @response['error'] && @response['error']['message']
    end

    def error_data
      @response['error'] && @response['error']['data']
    end

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
