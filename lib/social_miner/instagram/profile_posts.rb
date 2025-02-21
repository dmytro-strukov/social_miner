# frozen_string_literal: true

module SocialMiner
  module Instagram
    class ProfilePosts < Base
      PER_PAGE = 12
      QUERY_HASH = "69cba40317214236af40e7efa697781d"

      def call(user_id:, cursor: nil)
        uri = URI(GRAPHQL_URL)

        variables = { id: user_id, first: PER_PAGE }
        variables[:after] = cursor if cursor

        uri.query = URI.encode_www_form([
                                          [:query_hash, QUERY_HASH],
                                          [:variables, variables.to_json]
                                        ])

        response = Net::HTTP.get_response(uri, request_headers)

        case response
        when Net::HTTPSuccess
          response_data  = JSON.parse(response.body)
          timeline_media = Helpers::Hash.fetch_nested(response_data,
                                                      "data",
                                                      "user",
                                                      "edge_owner_to_timeline_media")

          cursor  = Helpers::Hash.fetch_nested(timeline_media, "page_info", "end_cursor")
          records = timeline_media.fetch("edges").map { |attrs| attrs.fetch("node") }

          if block_given?
            yield(records, cursor)
          else
            {
              records: records.map { |record| SocialMiner.mapper_for_klass(self.class).map(record) },
              cursor: cursor
            }
          end
        else
          raise Net::HTTPError.new("Request Failed #{response.code}", response)
        end
      end
    end
  end
end
