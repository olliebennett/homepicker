require 'nokogiri'
require 'open-uri'

class LinkRetrieverService
  def self.retrieve(url)
    page_html = URI.open(url) { |f| f.read }

    if url.include?('zoopla.co') # .com or .co.uk both supported!
      parse_zoopla(page_html)
    elsif url.include?('rightmove.co.uk')
      parse_rightmove(page_html)
    else
      raise "Unhandled URL: #{url}"
    end
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
    data[:title] = data[:title].gsub('for sale', '').squish

    data[:latitude] = res_data['geo']['latitude']
    data[:longitude] = res_data['geo']['longitude']

    # latlong = page_html.match(/"coordinates":{"latitude":(?<lat>\-?[0-9\.]+),"longitude":(?<long>\-?[0-9\.]+)}/)
    # data[:longitude] = latlong[:long]
    # data[:latitude] = latlong[:lat]

    data[:description] = html_to_markdown(page.css('.dp-description__text')[0])

    data[:canonical_url] = page.xpath("//link[@rel='canonical']/@href")&.to_s

    data[:address_street] = res_data['address']['streetAddress']
    raise "ZOOPLA: cannot find address_street..." if data[:address_street].blank?

    data[:address_locality] = res_data['address']['addressLocality']
    raise "ZOOPLA: cannot find address_locality..." if data[:address_locality].blank?

    data[:address_region] = res_data['address']['addressRegion']

    # Clean up street address to remove duplication;
    # Zoopla street addresses often end in "street, Locality OUTCODE", eg '... Bath BA1'
    if data[:address_street].end_with?(outcode)
      data[:address_street] = data[:address_street][0...- outcode.length].squish
      data[:address_street] = data[:address_street][0...-1].squish if data[:address_street].end_with?(',')
    end
    if data[:address_street].end_with?(data[:address_locality])
      data[:address_street] = data[:address_street][0...- data[:address_locality].length].squish
      data[:address_street] = data[:address_street][0...-1].squish if data[:address_street].end_with?(',')
    end

    raw_price = page.css('.ui-pricing__main-price')[0].text.squish
    data[:price] = raw_price.match(/[\d\,\.]{5,}/)[0].tr(',','').to_i

    data[:images] = res_data['photo'].map { |x| x['contentUrl'] }

    data
  end

  def self.parse_rightmove(page_html)
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

  def self.html_to_markdown(container_node)
    res = ''
    container_node.children.each do |child_node|
      case child_node.name
      when 'text', 'strong', 'em'
        res += child_node.text.squish
      when 'br'
        res += "\n"
      else
        raise "Unexpected child_node name; #{child_node.name}"
      end
    end

    res
  end
end
