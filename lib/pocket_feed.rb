require "httparty"
require "rss"
require_relative "bookmark"

class PocketFeed
  def initialize(username, password)
    @username = username
    @password = password
  end
  
  def feed
    @feed ||= begin
      response = HTTParty.get("http://getpocket.com/users/noniq/feed/all", basic_auth: { username: @username, password: @password })
      raise "Error loading RSS feed: #{response.body}" unless response.code == 200
      RSS::Parser.parse(response)
    end
  end
  
  def bookmarks(options = {})
    items = feed.items.dup
    items.reject!{ |item| item.pubDate < options[:since] } if options[:since]
    items.map{ |item| Bookmark.new(item.link, item.title) }
  end
  
end
