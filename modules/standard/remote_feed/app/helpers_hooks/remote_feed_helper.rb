require 'open-uri'

module ApplicationHelper
  # Try to read from cache. If the cache does not exist or old, get new feed
  # from remote server and update cache if succeed. If fail, try to reuse the
  # old cache if available.
  def remote_feed_block(block)
    feed = nil
    cache = Rails.cache.read('remote_feed')
    if cache.nil? || Time.now - cache[:updated_at] > CONF[:remote_feed][:cache_ttl].minutes
      begin
        timeout(CONF[:remote_feed][:timeout]) do
          uri = URI.parse(block.url)  # open() has been overidden by HAML?
          uri.open do |f|
            text = f.read
            parser = (block.type == 'ATOM')? Syndication::Atom::Parser.new : Syndication::RSS::Parser.new
            feed = parser.parse(text)
          end
        end

        cache = {:updated_at => Time.now, :feed => feed}
        Rails.cache.write('remote_feed', cache)
      rescue Exception
        feed = cache.nil? ? nil : cache[:feed]
      end
    else
      feed = cache[:feed]
    end

    feed = remote_feed_unify_feed(feed, block) unless feed.nil?
    content = feed.nil? ? '' : render('remote_feed_block/show', :block => block, :feed => feed)

    [block.title, content]
  end

  #-----------------------------------------------------------------------------

  # Convert feed to array [{:name, :link}].
  def remote_feed_unify_feed(feed, block)
    ret = []
    count = 0
    if block.type == 'ATOM'
      feed.entries.each do |e|
        ret << {:name => e.title.txt, :link => e.links[0].href}
        count += 1
        break if count == block.limit
      end
    else
      feed.items.each do |i|
        ret << {:name => i.title, :link => i.link}
        count += 1
        break if count == block.limit
      end
    end
    ret
  rescue
    nil
  end
end
