require 'json'
require 'byebug'

module TiktokScraper
  class Hashtag
    
    def self.get_posts(hashtag, count = 100)
      raw_results = TiktokScraper.get("/public/discover/hashtag?keyword=#{hashtag}&count=#{count}").parsed_response

      byebug
      results = raw_results["challengeInfoList"].first["itemList"].collect do |item_attrs|
        TiktokScraper::Video.new(TiktokScraper.to_recursive_ostruct(item_attrs))
      end
      results
      #JSON.parse(raw_results, object_class: OpenStruct).collect {|raw_attrs| TiktokScraper::Video.new(raw_attrs) }
    end
  end
end