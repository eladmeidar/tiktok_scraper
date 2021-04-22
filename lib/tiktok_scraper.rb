require 'httparty'
require "tiktok_scraper/version"
require "tiktok_scraper/models/video"
require "tiktok_scraper/hashtag"
require 'ostruct'

module TiktokScraper
  class Error < StandardError; end
  class HashtagNotFound < StandardError; end
  
  include HTTParty


  base_uri 'https://api.tikapi.io'
  format :json

  default_options.update(verify: false)
  
  # use this to config HTTParty stuff
  def self.configure(&block)
    yield(self)
  end

  def self.api_key(new_api_key)
    if new_api_key
      @api_key = new_api_key
      headers("X-API-KEY" => @api_key)
    end
    @api_key 
  end

  def self.proxy(proxy_string)
    host, port = proxy.split(":")
    self.http_proxy host, port.to_i
  end

  def self.to_recursive_ostruct(hash)
    OpenStruct.new(hash.each_with_object({}) do |(key, val), memo| 
      memo[key] = val.is_a?(Hash) ? to_recursive_ostruct(val) : val
    end)
  end
end
