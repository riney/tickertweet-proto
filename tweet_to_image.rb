require "rubygems"
require "bundler/setup"
Bundler.require(:default)
require 'open-uri'

module TickerTweet
  class TweetToImage
    DEFAULT_WIDTH = 600
    DEFAULT_FILENAME = "tweet.pbm"
    ICON_SCALE_FACTOR = "400%"
    
    REASONABLY_SMALL_ICON_WIDTH = 72
    
    def tweet_to_image(options = {})
      # parameter safety
      if options[:id].nil? && options[:json].nil?
        raise ArgumentError.new("You must pass either :id or :json for the tweet to convert")
      end
      
      width = options[:width] || DEFAULT_WIDTH
      filename = options[:filename] || DEFAULT_FILENAME
      
      # if :json is passed, take it away
      if !options[:json].nil?
        tweet = options[:json]
      # if :id is passed, fetch that tweet and get that sweet, sweet json
      elsif !options[:id].nil?
        id = Integer(options[:id]) rescue raise(ArgumentError.new(":id must be numeric"))
        tweet = Twitter.status id
      end
      
      # now we've got some json. get some useful thingies.
      decoder = HTMLEntities.new
      text               = decoder.decode(tweet[:text])
      created_at         = tweet[:created_at]
      #user               = tweet[:user]

      screen_name        = tweet[:from_user]
      #name               = user[:name]
      profile_image_url  = tweet[:profile_image_url].sub("normal", "reasonably_small")
            
      # let's cook some bitchin' images
      text = Magick::Image.read("caption:#{text}") do |text|
        text.size      = width.to_s
        text.pointsize = 36
        text.antialias = true
      end
      
      icon_stream = Net::HTTP.get_response(URI.parse(profile_image_url)).body
      factor = ICON_SCALE_FACTOR
      icon = Magick::Image.from_blob(icon_stream) do |icon|
      end
      
      byline = Magick::Image.read("caption:@#{screen_name}") do |byline|
        byline.size = (width - REASONABLY_SMALL_ICON_WIDTH).to_s
        byline.pointsize = 64
        byline.antialias = true
      end
      
      dateline = Magick::Image.read("caption:#{Time.parse(created_at).strftime("%Y-%m-%d %H:%M:%S")} - #{tweet[:id]}") do |dateline|
        dateline.size = (width - REASONABLY_SMALL_ICON_WIDTH).to_s
        dateline.pointsize = 24
        dateline.antialias = true
      end
      
      header_text = Magick::ImageList.new
      header_text << byline.first
      header_text << dateline.first
      
      header = Magick::ImageList.new
      header << icon.first
      header << header_text.append(true)

      image = Magick::ImageList.new
      image << header.append(false)
      image << text.first

      image.append(true).write("tweetz.pbm")
    end
  end
end
