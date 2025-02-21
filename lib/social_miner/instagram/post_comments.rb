# frozen_string_literal: true

module SocialMiner
  module Instagram
    class PostComments < Base
      DOC_ID = "8845758582119845"

      def call(post_shortcode:, cursor: nil)
        variables = { shortcode: post_shortcode }
        variables[:after] = cursor if cursor

        data = {
          "variables" => { shortcode: post_shortcode }.to_json,
          "doc_id" => DOC_ID
        }

        response = Net::HTTP.post_form(URI(GRAPHQL_URL), data)

        case response
        when Net::HTTPSuccess
          response_data = JSON.parse(response.body)

          edge_media = Helpers::Hash.fetch_nested(response_data,
                                                  "data",
                                                  "xdt_shortcode_media",
                                                  "edge_media_to_parent_comment")

          cursor = Helpers::Hash.fetch_nested(edge_media, "page_info", "end_cursor")
                                .then { |data| JSON.parse(data) }
                                .then { |data| data.fetch("server_cursor") }

          records = edge_media.fetch("edges").map { |edge| edge.fetch("node") }

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
