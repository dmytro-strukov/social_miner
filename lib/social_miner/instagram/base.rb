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

      private

      def http_client(uri)
        proxy = SocialMiner::Configuration.config.proxy

        if proxy
          Net::HTTP.new(uri.host, uri.port, proxy.host, proxy.port, proxy.user, proxy.password)
        else
          Net::HTTP.new(uri.host, uri.port)
        end
      end

      def get_response(uri)
        client = http_client(uri)
        client.use_ssl = uri.scheme == "https"

        request = Net::HTTP::Get.new(uri)
        request_headers.each { |key, value| request[key] = value }

        client.request(request)
      end

      def post_response(uri, form_data)
        client = http_client(uri)
        client.use_ssl = uri.scheme == "https"

        request = Net::HTTP::Post.new(uri)
        request_headers.each { |key, value| request[key] = value }
        request.set_form_data(form_data)

        client.request(request)
      end
    end
  end
end
