# frozen_string_literal: true

module SocialMiner
  module Instagram
    module CommentMapper
      def map(attrs)
        published_at = Time.at(attrs["created_at"]) if attrs["created_at"]

        {
          social_id: attrs.fetch("id"),
          body: attrs.fetch("text"),
          published_at: published_at
        }
      end

      module_function :map
    end
  end
end
