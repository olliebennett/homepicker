# frozen_string_literal: true

class ZooplaHomeImporter < HomeImporter
  def parse
    @data[:zoopla_url] = @page.xpath("//link[@rel='canonical']/@href")&.to_s

    parse_postcode

    parse_coords

    parse_title_description

    parse_address

    parse_price

    parse_images

    @data
  end

  def parse_address
    @data[:address_street] = res_data&.dig('address', 'streetAddress')

    @data[:address_locality] = res_data&.dig('address', 'addressLocality')

    @data[:address_region] = res_data&.dig('address', 'addressRegion')

    cleanup_address
  end

  def parse_coords
    @data[:latitude] = res_data&.dig('geo', 'latitude')&.to_f&.round(6)
    @data[:longitude] = res_data&.dig('geo', 'longitude')&.to_f&.round(6)
  end

  def parse_images
    @data[:images] = res_data['photo'].map { |x| x['contentUrl'] }
  end

  def parse_price
    raw_price = @page.css('.ui-pricing__main-price')&.first&.text&.squish
    @data[:price] = raw_price == 'POA' ? 0 : raw_price.match(/[\d,.]{5,}/)[0].tr(',', '').to_i
  end

  def parse_postcode
    incode = @page_html.match(/incode: "([A-Z0-9]{3,4})"/)[1]
    outcode = @page_html.match(/outcode: "([A-Z0-9]{3,4})"/)[1]
    @data[:postcode] = "#{outcode} #{incode}"
  end

  def parse_title_description
    title = res_data['name']
    @data[:title] = title&.gsub('for sale', '')&.squish

    @data[:description] = html_to_markdown(@page.css('.dp-description__text')&.first)
  end

  def res_data
    return @res_data if @res_data.present?

    ld_scripts = @page.xpath("//script[@type='application/ld+json']")
    ld_script_content = ld_scripts.last.text
    ld_data = JSON.parse(ld_script_content)

    @res_data = ld_data['@graph'].last
  end
end
