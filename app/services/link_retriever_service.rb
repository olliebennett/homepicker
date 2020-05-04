require 'nokogiri'
require 'open-uri'

class LinkRetrieverService
  def self.retrieve(url)
    page_html = URI.open(url) { |f| f.read }

    parse_zoopla(page_html)
  end

  def self.parse_zoopla(page_html)
    page = Nokogiri::HTML(page_html)

    puts "ZOOPLA: starting..."

    data = {}

    incode = page_html.match(/incode: "([A-Z0-9]{3,4})"/)[1]
    outcode = page_html.match(/outcode: "([A-Z0-9]{3,4})"/)[1]
    data[:postcode] = "#{outcode} #{incode}"

    raise "ZOOPLA: cannot find postcode..." if data[:postcode].blank?

    ld_scripts = page.xpath("//script[@type='application/ld+json']")
    ld_script_content = ld_scripts.last.text
    ld_data = JSON.parse(ld_script_content)

    res_data = ld_data['@graph'].last

    raise "ZOOPLA: cannot find res_data..." if res_data.blank?

    data[:title] = res_data['name']
    raise "ZOOPLA: cannot find title..." if data[:title].blank?

    data[:latitude] = res_data['geo']['latitude']
    data[:longitude] = res_data['geo']['longitude']

    # latlong = page_html.match(/"coordinates":{"latitude":(?<lat>\-?[0-9\.]+),"longitude":(?<long>\-?[0-9\.]+)}/)
    # data[:longitude] = latlong[:long]
    # data[:latitude] = latlong[:lat]

    data[:description] = page.css('.dp-description__text')[0].text.squish

    data[:canonical_url] = page.xpath("//link[@rel='canonical']/@href")&.to_s

    data[:address_street] = res_data['address']['streetAddress']
    raise "ZOOPLA: cannot find address_street..." if data[:address_street].blank?

    data[:address_locality] = res_data['address']['addressLocality']
    raise "ZOOPLA: cannot find address_locality..." if data[:address_locality].blank?
    data[:address_region] = res_data['address']['addressRegion']

    # data[:address] = page.xpath("//h2[@itemprop='streetAddress']").try(:text).try(:to_s)

    raw_price = page.css('.ui-pricing__main-price')[0].text.squish
    data[:price] = raw_price.match(/[\d\,\.]{5,}/)[0].tr(',','').to_i

    data[:images] = res_data['photo'].map { |x| x['contentUrl'] }
    # data[:images] = page.css('.dp-gallery__image').map { |x| x['src'] }

    data
  end
end
