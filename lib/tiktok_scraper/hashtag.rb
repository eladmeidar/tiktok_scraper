require 'json'

module TiktokScraper
  class Hashtag
    MAX_POSTS_PER_PAGE = 20

    def self.get_posts(hashtag, count = 100)
      videos = []
      
      hashtag_id = get_hashtag_id(hashtag)
      puts "HASHTAG ID: #{hashtag_id}"

      result = get_hashtag_posts(hashtag_id)
      
      videos = videos.concat(result[:items])

      while result[:has_more] && videos.length <= count
        result = get_hashtag_posts(hashtag_id, result[:cursor])
      
        videos = videos.concat(result[:items])
      end
      
      videos.uniq {|vid| vid.id }.slice(0...count)
    end

    protected

    def self.get_hashtag_posts(hashtag_id, cursor = nil)
      query = {
        id: hashtag_id
      }

      if cursor
        query[:cursor] = cursor
      end

      results = TiktokScraper.get('/public/hashtag', query: query).parsed_response
      
      return {
        cursor: results["cursor"],
        items: JSON.parse(results["itemList"].to_json, object_class: OpenStruct).collect {|raw_attrs| TiktokScraper::Video.new(raw_attrs) },
        has_more: results["hasMore"]
      }
    end

    def self.get_hashtag_id(hashtag)
      query = {
        name: hashtag
      }

      results = TiktokScraper.get('/public/hashtag', query: query).parsed_response

      return results["challenge"]["id"]
    end
  end
end