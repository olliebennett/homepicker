# frozen_string_literal: true

class RightmoveHomeImporter < HomeImporter
  def parse
    @data[:rightmove_url] = @page.xpath("//meta[@property='og:url']/@content")&.to_s

    parse_basic_fields
    parse_extra_fields

    cleanup_address
    combine_fields

    @data
  end

  private

  def parse_basic_fields
    parse_address
    parse_price
    parse_coords
    parse_description
    parse_title
    parse_status
    parse_images
  end

  def parse_extra_fields
    parse_key_features
    parse_floorplans
  end

  def property_json
    return @property_json if @property_json.present?

    property_json_string = @page_html.match(%r{<script>\s*window\.PAGE_MODEL = (.*?)\s*(</script>|window\.adInfo)})

    return if property_json_string.nil?

    @property_json = JSON.parse(property_json_string[1])
  end

  def parse_address
    return if property_json.nil?

    address = property_json.dig('propertyData', 'address', 'displayAddress')

    return if address.nil?

    address_parts = address.split(',', 3)
    @data[:address_street], @data[:address_locality], @data[:address_region] = address_parts.map { |x| x&.squish }

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

  def parse_description
    return if property_json.nil?

    description = property_json.dig('propertyData', 'text', 'description')
    @data[:description] = html_to_plaintext(Nokogiri::HTML::DocumentFragment.parse(description)) if description
  end

  def parse_key_features
    return if property_json.nil?

    @data[:key_features] = property_json.dig('propertyData', 'keyFeatures')
  end

  def parse_floorplans
    return if property_json.nil?

    floorplans_data = property_json.dig('propertyData', 'floorplans')
    return if floorplans_data.nil?

    @data[:floorplans] = floorplans_data.select { |x| x['type'] == 'IMAGE' }.pluck('url')
  end

  def parse_images
    # Alternative data source:
    # @data[:images] = @page.xpath("//meta[@property='og:image']/@content").map(&:to_s)
    return if property_json.nil?

    images_data = property_json.dig('propertyData', 'images')
    return if images_data.nil?

    @data[:images] = images_data.pluck('url')
  end

  def parse_title
    return if property_json.nil?

    @data[:title] = property_json.dig('propertyData', 'text', 'pageTitle')
  end

  def parse_status
    @data[:listing_status] = if @response_status == '410'
                               :removed
                             else
                               :okay
                             end
  end
end
