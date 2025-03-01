# frozen_string_literal: true

module SocialMiner
  class Configuration
    class << self
      def configure
        yield(config)
      end

      def config
        @config ||= new
      end
    end

    attr_reader :proxy

    def initialize
      @proxy = nil
    end

    def proxy=(proxy_url)
      @proxy = URI(proxy_url)
    end
  end
end
