# frozen_string_literal: true

RSpec.describe SocialMiner::Instagram::ProfileInfo do
  let(:username) { "test_user" }
  let(:success_response) do
    {
      "data" => {
        "user" => {
          "id" => "123456",
          "username" => "test_user",
          "biography" => "Test bio",
          "full_name" => "Test User",
          "profile_pic_url" => "http://example.com/pic.jpg",
          "edge_followed_by" => { "count" => 100 },
          "edge_follow" => { "count" => 200 }
        }
      }
    }.to_json
  end

  subject(:profile_info) { SocialMiner::Instagram.profile_info(username: username) }

  describe "#call" do
    before do
      stub_request(:get, "#{described_class::URL}?username=#{username}")
        .to_return(status: 200, body: success_response)
    end

    it "fetches and maps profile information correctly" do
      expect(profile_info).to include(
        social_id: "123456",
        username: "test_user",
        description: "Test bio",
        full_name: "Test User",
        avatar_url: "http://example.com/pic.jpg",
        followers: 100,
        following: 200
      )
    end

    context "when request fails" do
      before do
        stub_request(:get, "#{described_class::URL}?username=#{username}")
          .to_return(status: 404, body: "Not Found")
      end

      it "raises an error" do
        expect { profile_info }
          .to raise_error(Net::HTTPError, /Request Failed 404/)
      end
    end
  end
end
