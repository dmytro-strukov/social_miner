# frozen_string_literal: true

module SocialMiner
  module Instagram
    module ProfileMapper
      def map(attrs)
        {
          social_id: attrs.fetch("id"),
          description: attrs["biography"],
          username: attrs.fetch("username"),
          full_name: attrs.fetch("full_name"),
          avatar_url: attrs.fetch("profile_pic_url"),
          followers: Helpers::Hash.fetch_nested(attrs, "edge_followed_by", "count"),
          following: Helpers::Hash.fetch_nested(attrs, "edge_follow", "count")
        }
      end

      module_function :map
    end
  end
end
