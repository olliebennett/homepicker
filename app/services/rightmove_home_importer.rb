# frozen_string_literal: true

class RightmoveHomeImporter < HomeImporter
  def parse
    @data[:rightmove_url] = @page.xpath("//meta[@property='og:url']/@content")&.to_s

    parse_address
    parse_price
    parse_coords
    parse_title_description
    parse_images

    @data
  end

  def property_json
    return @property_json if @property_json.present?

    property_json_string = @page_html.match(/window\.PAGE_MODEL = {(.*)}/)

    return if property_json_string.nil?

    @property_json = JSON.parse("{#{property_json_string[1]}}")
  end

  def parse_address
    return if property_json.nil?

    address = property_json.dig('propertyData', 'address', 'displayAddress')

    return if address.nil?

    address_parts = address.split(',', 3)
    @data[:address_street] = address_parts[0]
    @data[:address_locality] = address_parts[1]
    @data[:address_region] = address_parts[2] || 'UNKNOWN'

    @data[:postcode] = property_json.dig('analyticsInfo', 'analyticsProperty', 'postcode')
  end

  def parse_price
    return if property_json.nil?

    @data[:price] = property_json.dig('analyticsInfo', 'analyticsProperty', 'price')
    @data[:price] = 0 if @data[:price].blank?
  end

  def parse_coords
    return if property_json.nil?

    @data[:latitude] = property_json.dig('analyticsInfo', 'analyticsProperty', 'latitude')
    @data[:longitude] = property_json.dig('analyticsInfo', 'analyticsProperty', 'longitude')
  end

  def parse_title_description
    return if property_json.nil?

    @data[:title] = property_json.dig('propertyData', 'text', 'pageTitle')

    description = property_json.dig('propertyData', 'text', 'description')
    @data[:description] = html_to_markdown(Nokogiri::HTML::DocumentFragment.parse(description)) if description
  end

  def parse_images
    @data[:images] = @page.xpath("//meta[@property='og:image']/@content").map(&:to_s)
  end
end
