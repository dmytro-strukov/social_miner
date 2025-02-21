# frozen_string_literal: true

RSpec.describe SocialMiner::Helpers::Hash do
  describe ".fetch_nested" do
    let(:hash) do
      {
        "data" => {
          "user" => {
            "profile" => {
              "name" => "John Doe"
            }
          }
        }
      }
    end

    it "fetches nested value successfully" do
      expect(described_class.fetch_nested(hash, "data", "user", "profile", "name")).to eq("John Doe")
    end

    it "raises KeyError when key does not exist" do
      expect { described_class.fetch_nested(hash, "data", "invalid", "name") }.to raise_error(KeyError)
    end
  end
end
