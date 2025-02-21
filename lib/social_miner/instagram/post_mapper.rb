# frozen_string_literal: true

module SocialMiner
  module Instagram
    module PostMapper
      def map(attrs)
        published_at = Time.at(attrs["taken_at_timestamp"]) if attrs["taken_at_timestamp"]

        {
          social_id: attrs.fetch("id"),
          image_url: attrs.fetch("display_url"),
          shortcode: attrs.fetch("shortcode"),
          location_name: attrs.dig("location", "name"),
          description: description(attrs.dig("edge_media_to_caption", "edges")),
          published_at: published_at
        }
      end

      module_function :map

      def description(edges)
        edge = edges&.first
        edge&.dig("node", "text")
      end

      module_function :description
      private_class_method :description
    end
  end
end
