# frozen_string_literal: true

class LinkRetrieverService
  def self.retrieve(url)
    res = Net::HTTP.get_response(URI(url))

    # Note: Rightmove returns a 410 (Gone) when property has been 'removed by agent'
    raise "Unsuccessful response: #{res.code} for #{url}" unless %w[200 410].include?(res.code)

    if url.include?('zoopla.co') # .com or .co.uk both supported!
      ZooplaHomeImporter.new(res.body, res.code).parse
    elsif url.include?('rightmove.co.uk')
      RightmoveHomeImporter.new(res.body, res.code).parse
    else
      raise "Unhandled URL: #{url}"
    end
  end
end
