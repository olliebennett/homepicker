require 'open-uri'

class LinkRetrieverService
  def self.retrieve(url)
    page_html = URI.open(url) { |f| f.read }

    if url.include?('zoopla.co') # .com or .co.uk both supported!
      ZooplaHomeImporter.parse(page_html)
    elsif url.include?('rightmove.co.uk')
      RightmoveHomeImporter.parse(page_html)
    else
      raise "Unhandled URL: #{url}"
    end
  end
end
