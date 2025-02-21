# frozen_string_literal: true

module SocialMiner
  module Instagram
    module FollowersMapper
      def map(attrs)
        {
          social_id: attrs.fetch("id"),
          username: attrs.fetch("username"),
          full_name: attrs.fetch("full_name"),
          avatar_url: attrs.fetch("profile_pic_url"),
          is_private: attrs.fetch("is_private"),
          is_verified: attrs.fetch("is_verified")
        }
      end

      module_function :map
    end
  end
end
