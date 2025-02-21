# frozen_string_literal: true

module SocialMiner
  module Helpers
    module Hash
      def fetch_nested(hash, *keys)
        val = hash.fetch(keys.shift)
        return val if keys.empty?

        fetch_nested(val, *keys)
      end

      module_function :fetch_nested
    end
  end
end
