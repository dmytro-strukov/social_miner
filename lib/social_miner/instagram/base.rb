# frozen_string_literal: true

require "json"

require "uri"
require "net/http"

module SocialMiner
  module Instagram
    class Base
      SOURCE_URL  = "https://www.instagram.com"

      API_URL     = "#{SOURCE_URL}/api/v1".freeze
      GRAPHQL_URL = "#{SOURCE_URL}/graphql/query/".freeze

      DEFAULT_HEADERS = {
        "X-IG-App-ID" => "936619743392459"
      }.freeze

      attr_reader :request_headers

      def initialize(request_headers = {})
        @request_headers = DEFAULT_HEADERS.merge(request_headers)
      end
    end
  end
end
