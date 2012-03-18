require "rubygems"
require "bundler/setup"
Bundler.require(:default)
require "./tweet_to_image"

module TickerTweet
  class TickerTweet
    DELAY = 60 # seconds
    
    def setup
      @search = Twitter::Search.new
      @tti = TweetToImage.new
      @start_time = Time.now
    end
    
    def loop
      last_id = 0
      while(1) do
        puts "running at #{Time.now}..."
        begin
          @search.hashtag("cookiehammer").since_id(last_id)

          c = 0
          @search.each do |result|
            puts "Printing tweet #{c+=1}"
            @tti.tweet_to_image(json: result)
            spawn "cat ~/gitroot/tickertweet-proto/tweetz.pbm | pnmnoraw | pbm2lwxl | lp -o raw"
            last_id = result[:id] if (result[:id].to_i > last_id.to_i)
          end
        
          @search.clear
        rescue Exception
          puts "Exception " + $!
        end
        
        sleep(DELAY)
      end
    end
    
  end
end

t = TickerTweet::TickerTweet.new
t.setup
t.loop
