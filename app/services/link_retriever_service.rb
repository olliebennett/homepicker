require 'nokogiri'
require 'open-uri'

class LinkRetrieverService
  def self.retrieve(url)
    puts "Retrieving link: #{url}"
    page = Nokogiri::HTML(open(url))

    data = {}
    # puts "Retrieved data: #{page}"
    data[:canonical_url] = page.xpath("//meta[@property='og:url']/@content")
    puts "canonical_url: #{data[:canonical_url]}"

    data[:address] = page.xpath("//meta[@property='og:street-address']/@content")
    puts "address: #{data[:address]}"
    data[:postcode] = page.xpath("//meta[@property='og:postal-code']/@content")
    puts "postcode: #{data[:postcode]}"

    data[:longitude] = page.xpath("//meta[@property='og:longitude']/@content")
    puts "longitude: #{data[:longitude]}"
    data[:latitude] = page.xpath("//meta[@property='og:latitude']/@content")
    puts "latitude: #{data[:latitude]}"

    data[:description] = page.xpath("//meta[@property='og:description']/@content").to_s.squish
    puts "description: #{data[:description]}"

    data[:price] = data[:description].match(/[\d\,\.]{5,}/)
    data[:price] = data[:price].to_s.tr(',','') if data[:price].present?
    puts "price: #{data[:price]}"

    data[:images] = page.xpath("//meta[@property='og:image']/@content").map(&:to_s)

    data
  end
end
