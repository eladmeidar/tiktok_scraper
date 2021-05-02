require 'json'

module TiktokScraper
  class Hashtag
    MAX_POSTS_PER_PAGE = 20

    def self.get_posts(hashtag, count = 100)
      videos = []
      
      result = get_hashtag_posts(hashtag)

      videos = videos.concat(result[:items])

      while result[:has_more] && videos.length <= count
        result = get_hashtag_posts(hashtag, result[:cursor])
        videos = videos.concat(result[:items])
      end
      
      videos.uniq {|vid| vid.id }.slice(0...count)
    end

    protected

    def self.get_hashtag_posts(hashtag, cursor = nil)
      query = {
        name: hashtag
      }

      if cursor
        query[:cursor] = cursor
      end

      results = TiktokScraper.get('/public/hashtag', query: query)
      
      return {
        cursor: results["cursor"],
        items: JSON.parse(results["itemList"].to_json, object_class: OpenStruct).collect {|raw_attrs| TiktokScraper::Video.new(raw_attrs) },
        has_more: results["hasMore"]
      }
    end

    def self.get_hashtag_id(hashtag)
      raw_results = TiktokScraper.get("/public/discover/hashtag", query: {keyword: hashtag, count: MAX_POSTS_PER_PAGE}).parsed_response
      id = raw_results["challengeInfoList"].first["challenge"]["id"]
      hashtag_name = raw_results["challengeInfoList"].first["challenge"]["title"]
      if id.nil? || hashtag_name.downcase != hashtag.downcase
        raise TiktokScraper::HashtagNotFound, "Hashtag '#{hashtag}' was not found"
      else
        id
      end
    end
  end
end