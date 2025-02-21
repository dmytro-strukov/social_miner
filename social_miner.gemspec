# frozen_string_literal: true

require_relative "lib/social_miner/version"

Gem::Specification.new do |spec|
  spec.name = "social_miner"
  spec.version = SocialMiner::VERSION
  spec.authors = ["null0vector"]
  spec.email = ["root@null0vector.com"]

  spec.summary = "SocialMiner is a Ruby gem that provides a simple interface to fetch public data from Instagram, \
    including user profiles, posts, and comments."

  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["source_code_uri"] = "https://github.com/null0vector/social_miner"
  spec.metadata["changelog_uri"] = "https://github.com/null0vector/social_miner/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.metadata["rubygems_mfa_required"] = "true"
end
