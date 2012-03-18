require "rubygems"
require "bundler/setup"
Bundler.require(:default)
require './tweet_to_image'

module TickerTweet
  class TweetToImageCli
    def self.main
      t = TickerTweet::TweetToImage.new
      puts t.tweet_to_image(id: 119548086430351360)
    end
  end
end

TickerTweet::TweetToImageCli.main