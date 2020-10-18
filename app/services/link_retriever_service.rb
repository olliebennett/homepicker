# frozen_string_literal: true

require 'open-uri'

class LinkRetrieverService
  def self.retrieve(url)
    page_html = URI.open(url, &:read)

    if url.include?('zoopla.co') # .com or .co.uk both supported!
      ZooplaHomeImporter.new(page_html).parse
    elsif url.include?('rightmove.co.uk')
      RightmoveHomeImporter.new(page_html).parse
    else
      raise "Unhandled URL: #{url}"
    end
  end
end
