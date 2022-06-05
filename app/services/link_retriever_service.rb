# frozen_string_literal: true

class LinkRetrieverService
  def self.retrieve(url)
    res = Net::HTTP.get_response(URI(url))

    raise "Unsuccessful response: #{res.code}" unless res.code == '200'

    if url.include?('zoopla.co') # .com or .co.uk both supported!
      ZooplaHomeImporter.new(res.body).parse
    elsif url.include?('rightmove.co.uk')
      RightmoveHomeImporter.new(res.body).parse
    else
      raise "Unhandled URL: #{url}"
    end
  end
end
