require 'nokogiri'
require 'open-uri'

class LinkRetrieverService
  def self.retrieve(url)
    file = open(url)

    parse_zoopla(file)
  end

  def self.parse_zoopla(file)
    page = Nokogiri::HTML(file)

    data = {}
    data[:canonical_url] = page.xpath("//link[@rel='canonical']/@href").try(:to_s)

    data[:address] = page.xpath("//h2[@itemprop='streetAddress']").try(:text).try(:to_s)

    data[:postcode] = page.xpath("//meta[@property='og:postal-code']/@content").try(:to_s)

    data[:longitude] = page.xpath("//meta[@itemprop='longitude']/@content").try(:to_s).try(:to_f)
    data[:latitude] = page.xpath("//meta[@itemprop='latitude']/@content").try(:to_s).try(:to_f)

    data[:description] = page.xpath("//div[@itemprop='description']").try(:text).try(:to_s).try(:squish)

    data[:price] = page.css('.listing-details-price.text-price')[0].text.squish
    data[:price] = data[:price].match(/[\d\,\.]{5,}/)[0].tr(',','').to_i

    data[:images] = page.xpath("//meta[@property='og:image']/@content").map(&:to_s)

    data
  end
end
