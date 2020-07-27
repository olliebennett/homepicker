class RightmoveHomeImporter < HomeImporter
  def self.parse(page_html)
    page = Nokogiri::HTML(page_html)

    puts "RIGHTMOVE: starting..."

    data = {}

    property_json_string = page_html.match(/'property',{"location":{(.*)}/)
    property_json = JSON.parse(property_json_string[0][11..-1])

    data[:postcode] = property_json.dig('location', 'postcode')
    raise "RIGHTMOVE: cannot find postcode..." if data[:postcode].blank?
    data[:latitude] = property_json.dig('location', 'latitude')
    data[:longitude] = property_json.dig('location', 'longitude')

    data[:price] = property_json.dig('propertyInfo', 'price')
    data[:price] = 0 if data[:price] == nil

    data[:title] = page.css('div.property-header-bedroom-and-price/div/h1')[0].text
    raise "RIGHTMOVE: cannot find title..." if data[:title].blank?
    data[:title] = data[:title].gsub('for sale', '').squish

    data[:description] = html_to_markdown(page.xpath("//p[@itemprop='description']")[0])

    data[:canonical_url] = page.xpath("//link[@rel='canonical']/@href")&.to_s

    address = page.css("div.property-header-bedroom-and-price/div/address/meta[@itemprop='streetAddress']/@content")[0].text
    raise "RIGHTMOVE: cannot find address..." if address.blank?

    data[:address_street], data[:address_locality] = address.split(',', 2)
    raise "RIGHTMOVE: cannot find address_locality..." if data[:address_locality].blank?

    data[:address_region] = 'UNKNOWN'

    data[:images] = page.xpath("//meta[@property='og:image']/@content").map(&:to_s)

    data
  end
end
