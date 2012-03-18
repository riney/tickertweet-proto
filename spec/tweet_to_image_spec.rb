# spec for TickerTweet::TweetToImage

require "rubygems"
require "bundler/setup"
Bundler.require(:default)
require './tweet_to_image'

describe TickerTweet::TweetToImage do
  describe "parameter safety" do
    before :each do
      @t = TickerTweet::TweetToImage.new
    end
    
    it "raises ArgumentError if neither :id or :json are passed as arguments" do
      expect { @t.tweet_to_image }.to raise_error(ArgumentError)
    end

    it "doesn't raise error if one of :id or :json are passed as arguments" do
      expect { @t.tweet_to_image(id: 12345) }.to_not raise_error
      expect { @t.tweet_to_image(json: "i am not really json") }.to_not raise_error
    end
    
    it "raises ArgumentError on a non-numeric :id" do
      expect { @t.tweet_to_image(id: "hufflepuff") }.to raise_error(ArgumentError)
    end
  end
  
end
