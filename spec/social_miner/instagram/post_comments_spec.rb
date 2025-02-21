# frozen_string_literal: true

RSpec.describe SocialMiner::Instagram::PostComments do
  let(:post_shortcode) { "ABC123" }
  let(:success_response) do
    {
      "data" => {
        "xdt_shortcode_media" => {
          "edge_media_to_parent_comment" => {
            "page_info" => {
              "end_cursor" => "{\"server_cursor\":\"next_page_token\"}"
            },
            "edges" => [
              {
                "node" => {
                  "id" => "comment123",
                  "text" => "Great post!",
                  "created_at" => 1_634_567_890
                }
              }
            ]
          }
        }
      }
    }.to_json
  end

  subject(:post_comments) { SocialMiner::Instagram.post_comments(post_shortcode: post_shortcode) }

  describe "#call" do
    before do
      stub_request(:post, described_class::GRAPHQL_URL)
        .with(
          body: hash_including(
            "variables" => { shortcode: post_shortcode }.to_json,
            "doc_id" => described_class::DOC_ID
          )
        )
        .to_return(status: 200, body: success_response)
    end

    it "fetches and maps comments correctly" do
      expect(post_comments[:cursor]).to eq("next_page_token")
      expect(post_comments[:records]).to contain_exactly(
        include(
          social_id: "comment123",
          body: "Great post!",
          published_at: Time.at(1_634_567_890)
        )
      )
    end

    context "when request fails" do
      before do
        stub_request(:post, described_class::GRAPHQL_URL)
          .to_return(status: 404, body: "Not Found")
      end

      it "raises an error" do
        expect { post_comments }
          .to raise_error(Net::HTTPError, /Request Failed 404/)
      end
    end
  end
end
