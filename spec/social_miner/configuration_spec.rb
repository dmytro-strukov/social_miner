# frozen_string_literal: true

RSpec.describe SocialMiner::Configuration do
  describe ".configure" do
    after { described_class.instance_variable_set(:@config, nil) }

    it "configures proxy with valid URL" do
      proxy_url = "http://user:pass@proxy.example.com:8080"

      described_class.configure do |config|
        config.proxy = proxy_url
      end

      proxy = described_class.config.proxy

      expect(proxy).to be_a(URI)
      expect(proxy.scheme).to eq("http")
      expect(proxy.user).to eq("user")
      expect(proxy.password).to eq("pass")
      expect(proxy.host).to eq("proxy.example.com")
      expect(proxy.port).to eq(8080)
    end
  end
end
