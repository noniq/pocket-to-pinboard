require "pinboard"

class PinboardClient
  def initialize(username, password, options = {})
    @username = username
    @password = password
    @options = { replace: false, shared: false }.merge(options)
  end
  
  def client
    @client ||= Pinboard::Client.new(username: @username, password: @password)
  end
  
  def add_bookmarks(bookmarks)
    bookmarks.each do |bookmark|
      add_bookmark(bookmark)
    end
  end
  
  def add_bookmark(bookmark)
    client.add(@options.merge(url: bookmark.url, description: bookmark.description))
  rescue Pinboard::Error => e
    if e.message == "item already exists"
      puts "Bookmark already exists, skipping it: #{bookmark.url}"
    else
      raise e
    end
  end
end