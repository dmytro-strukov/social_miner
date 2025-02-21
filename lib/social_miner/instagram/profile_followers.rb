# frozen_string_literal: true

module SocialMiner
  module Instagram
    class ProfileFollowers < Base
      PER_PAGE = 12

      # Requires authentication
      # The next cookies should be provided: csrftoken, ds_user_id, sessionid
      # The next headers should be provided: cookie, x-web-session-id, user_id
      # SocialMiner::Instagram.profile_followers(
      #   {
      #     'cookie' => 'csrftoken=example_value; ds_user_id=example_value; sessionid=example_value',
      #     'x-web-session-id' => 'example_value'
      #   }, user_id: 123456789
      # )
      def call(user_id:, next_max_id: nil)
        uri = URI("#{API_URL}/friendships/#{user_id}/followers/")
        uri.query = URI.encode_www_form([
                                          [:count, PER_PAGE],
                                          %i[search_surface follow_list_page],
                                          [:max_id, next_max_id]
                                        ])

        response = Net::HTTP.get_response(uri, request_headers)

        case response
        when Net::HTTPSuccess
          response_data = JSON.parse(response.body)
          records = response_data.fetch("users")

          if block_given?
            yield(records, response_data["next_max_id"])
          else
            {
              records: records.map { |record| SocialMiner.mapper_for_klass(self.class).map(record) },
              next_max_id: response_data["next_max_id"]
            }
          end
        else
          raise Net::HTTPError.new("Request Failed #{response.code}", response)
        end
      end
    end
  end
end
