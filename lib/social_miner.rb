# frozen_string_literal: true

require_relative "social_miner/version"
require_relative "social_miner/helpers/hash"
require_relative "social_miner/configuration"

require_relative "social_miner/instagram/base"
require_relative "social_miner/instagram/profile_info"
require_relative "social_miner/instagram/profile_mapper"
require_relative "social_miner/instagram/profile_followers"
require_relative "social_miner/instagram/followers_mapper"
require_relative "social_miner/instagram/profile_posts"
require_relative "social_miner/instagram/post_mapper"
require_relative "social_miner/instagram/post_comments"
require_relative "social_miner/instagram/comment_mapper"

module SocialMiner
  DEFAULT_MAPPERS = {
    Instagram::ProfileInfo => Instagram::ProfileMapper,
    Instagram::ProfileFollowers => Instagram::FollowersMapper,
    Instagram::ProfilePosts => Instagram::PostMapper,
    Instagram::PostComments => Instagram::CommentMapper
  }.freeze

  def mapper_for_klass(key)
    DEFAULT_MAPPERS.fetch(key)
  end

  module_function :mapper_for_klass

  def self.configure(&)
    Configuration.configure(&)
  end

  # Requires authentication
  def Instagram.profile_followers(request_headers = {}, **args, &)
    Instagram::ProfileFollowers.new(request_headers).call(**args, &)
  end

  def Instagram.profile_info(request_headers = {}, **args, &)
    Instagram::ProfileInfo.new(request_headers).call(**args, &)
  end

  def Instagram.profile_posts(request_headers = {}, **args, &)
    Instagram::ProfilePosts.new(request_headers).call(**args, &)
  end

  def Instagram.post_comments(request_headers = {}, **args, &)
    Instagram::PostComments.new(request_headers).call(**args, &)
  end
end
