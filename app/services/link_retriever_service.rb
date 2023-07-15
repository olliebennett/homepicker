# frozen_string_literal: true

class LinkRetrieverService
  def self.retrieve(url)
    res = Net::HTTP.get_response(URI(strip_url_preamble(url)))

    # NOTE: Rightmove returns a 410 (Gone) when property has been 'removed by agent'
    raise "Unsuccessful response: #{res.code} for #{url}" unless %w[200 410].include?(res.code)

    retrieve_by_provider(url, res)
  end

  def self.retrieve_by_provider(url, res)
    if url.include?('zoopla.co') # .com or .co.uk both supported!
      ZooplaHomeImporter.new(res.body, res.code).parse
    elsif url.include?('rightmove.co.uk')
      RightmoveHomeImporter.new(res.body, res.code).parse
    else
      raise "Unhandled URL: #{url}"
    end
  end

  def self.strip_url_preamble(url)
    # Remove any words up to the first 'http' part of the URL
    url.sub(/[A-Za-z\: ]*http/, 'http')
  end
end
