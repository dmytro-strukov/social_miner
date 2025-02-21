# frozen_string_literal: true

module SocialMiner
  module Instagram
    class ProfileInfo < Base
      URL = "#{API_URL}/users/web_profile_info/".freeze

      def call(username:)
        uri = URI(URL)
        uri.query = URI.encode_www_form([
                                          [:username, username]
                                        ])

        response = Net::HTTP.get_response(uri, request_headers)

        case response
        when Net::HTTPSuccess
          response_data = JSON.parse(response.body)
          record = Helpers::Hash.fetch_nested(response_data, "data", "user")

          if block_given?
            yield(record)
          else
            SocialMiner.mapper_for_klass(self.class).map(record)
          end
        else
          raise Net::HTTPError.new("Request Failed #{response.code}", response)
        end
      end
    end
  end
end
