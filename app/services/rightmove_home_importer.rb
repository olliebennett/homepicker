# frozen_string_literal: true

class RightmoveHomeImporter < HomeImporter
  def self.parse(page_html)
    page = Nokogiri::HTML(page_html)

    data = {}

    data[:rightmove_url] = page.xpath("//meta[@property='og:url']/@content")&.to_s

    property_json_string = page_html.match(/window\.PAGE_MODEL = {(.*)}/)

    property_json = JSON.parse("{#{property_json_string[1]}}") if property_json_string.present?

    if property_json.present?
      data[:postcode] = property_json.dig('analyticsInfo', 'analyticsProperty', 'postcode')
      data[:latitude] = property_json.dig('analyticsInfo', 'analyticsProperty', 'latitude')
      data[:longitude] = property_json.dig('analyticsInfo', 'analyticsProperty', 'longitude')
      data[:price] = property_json.dig('analyticsInfo', 'analyticsProperty', 'price')
      data[:price] = 0 if data[:price].blank?

      data[:title] = property_json.dig('propertyData', 'text', 'pageTitle')

      description = property_json.dig('propertyData', 'text', 'description')
      data[:description] = html_to_markdown(Nokogiri::HTML::DocumentFragment.parse(description)) if description

      address = property_json.dig('propertyData', 'address', 'displayAddress')
      if address.present?
        address_parts = address.split(',', 3)
        data[:address_street] = address_parts[0]
        data[:address_locality] = address_parts[1]
        data[:address_region] = address_parts[2] || 'UNKNOWN'
      end
    end

    data[:images] = page.xpath("//meta[@property='og:image']/@content").map(&:to_s)

    data
  end
end
