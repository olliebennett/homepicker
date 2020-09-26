class ZooplaHomeImporter < HomeImporter
  def self.parse(page_html)
    page = Nokogiri::HTML(page_html)

    data = {}

    incode = page_html.match(/incode: "([A-Z0-9]{3,4})"/)[1]
    outcode = page_html.match(/outcode: "([A-Z0-9]{3,4})"/)[1]
    data[:postcode] = "#{outcode} #{incode}"

    ld_scripts = page.xpath("//script[@type='application/ld+json']")
    ld_script_content = ld_scripts.last.text
    ld_data = JSON.parse(ld_script_content)

    res_data = ld_data['@graph'].last

    title = res_data['name']
    data[:title] = title&.gsub('for sale', '')&.squish

    data[:latitude] = res_data&.dig('geo', 'latitude')
    data[:longitude] = res_data&.dig('geo', 'longitude')

    # latlong = page_html.match(/"coordinates":{"latitude":(?<lat>\-?[0-9\.]+),"longitude":(?<long>\-?[0-9\.]+)}/)
    # data[:longitude] = latlong[:long]
    # data[:latitude] = latlong[:lat]

    data[:description] = html_to_markdown(page.css('.dp-description__text')&.first)

    data[:zoopla_url] = page.xpath("//link[@rel='canonical']/@href")&.to_s

    data[:address_street] = res_data&.dig('address', 'streetAddress')

    data[:address_locality] = res_data&.dig('address', 'addressLocality')

    data[:address_region] = res_data&.dig('address', 'addressRegion')

    # Clean up street address to remove duplication;
    # Zoopla street addresses often end in "street, Locality OUTCODE", eg '... Bath BA1'
    if data[:address_street]&.end_with?(outcode)
      data[:address_street] = data[:address_street][0...- outcode.length].squish
      data[:address_street] = data[:address_street][0...-1].squish if data[:address_street].end_with?(',')
    end
    if data[:address_street]&.end_with?(data[:address_locality])
      data[:address_street] = data[:address_street][0...- data[:address_locality].length].squish
      data[:address_street] = data[:address_street][0...-1].squish if data[:address_street].end_with?(',')
    end

    raw_price = page.css('.ui-pricing__main-price')&.first&.text&.squish
    data[:price] = raw_price == 'POA' ? 0 : raw_price.match(/[\d\,\.]{5,}/)[0].tr(',','').to_i

    data[:images] = res_data['photo'].map { |x| x['contentUrl'] }

    data
  end
end
