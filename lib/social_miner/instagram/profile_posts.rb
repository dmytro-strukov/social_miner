# frozen_string_literal: true

module SocialMiner
  module Instagram
    class ProfilePosts < Base
      PER_PAGE = 12
      QUERY_HASH = "7950326061742207"

      def call(user_id:, cursor: nil)
        uri = URI(GRAPHQL_URL)

        variables = { id: user_id, first: PER_PAGE }
        variables[:after] = cursor if cursor

        uri.query = URI.encode_www_form([
                                          [:doc_id, QUERY_HASH],
                                          [:variables, variables.to_json]
                                        ])

        response = get_response(uri)

        case response
        when Net::HTTPSuccess
          response_data  = JSON.parse(response.body)
          timeline_media = Helpers::Hash.fetch_nested(response_data,
                                                      "data",
                                                      "user",
                                                      "edge_owner_to_timeline_media")

          has_next_page = Helpers::Hash.fetch_nested(timeline_media, "page_info", "has_next_page")
          next_page_cursor = Helpers::Hash.fetch_nested(timeline_media, "page_info", "end_cursor") if has_next_page

          records = timeline_media.fetch("edges").map { |attrs| attrs.fetch("node") }
          count   = timeline_media.fetch("count")

          if block_given?
            yield(records, next_page_cursor, count)
          else
            {
              records: records.map { |record| SocialMiner.mapper_for_klass(self.class).map(record) },
              cursor: next_page_cursor,
              count: count
            }
          end
        else
          raise Net::HTTPError.new("Request Failed #{response.code}", response)
        end
      end
    end
  end
end
