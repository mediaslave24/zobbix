require 'zobbix/api_request'

class Zobbix
  module Apiinfo
    class VersionRequest < ApiRequest
      def initialize(uri)
        super(uri, 'apiinfo.version', {})
      end
    end
  end
end
