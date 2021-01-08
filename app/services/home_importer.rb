# frozen_string_literal: true

require 'nokogiri'

class HomeImporter
  def initialize(page_html)
    @page_html = page_html.squish
    @page = Nokogiri::HTML(page_html)
    @data = {}
  end

  private

  def cleanup_address
    remove_duplicated_postcode

    remove_duplicated_region

    remove_duplicated_locality

    remove_duplicated_street

    remove_trailing_title_in
  end

  def combine_fields
    combine_floorplan
    combine_key_features
  end

  def combine_floorplan
    return if @data[:floorplans].blank?

    @data[:images] = @data[:images].concat(@data[:floorplans])
  end

  def combine_key_features
    return if @data[:key_features].blank?

    desc_prefix = "Key Features:\n\n- #{@data[:key_features].join("\n- ")}\n\n"
    @data[:description] = "#{desc_prefix}#{@data[:description]}"
  end

  def extract_outcode(postcode)
    postcode[0...-3].squish if postcode.present?
  end

  def remove_duplicated_postcode
    return if @data[:postcode].blank?

    postcode = @data[:postcode]
    outcode = postcode[0...-3].squish

    # None of these fields should include, or end with the postcode or outcode
    %i[title address_street address_locality address_region].each do |field|
      @data[field] = remove_occurrences(@data[field], postcode)
      @data[field] = remove_occurrences(@data[field], outcode)
    end
  end

  def remove_duplicated_region
    return if @data[:address_region].blank?

    region = @data[:address_region]

    # None of these fields should include, or end with the region
    %i[title address_street address_locality].each do |field|
      @data[field] = remove_occurrences(@data[field], region)
    end
  end

  def remove_duplicated_locality
    return if @data[:address_locality].blank?

    locality = @data[:address_locality]

    # None of these fields should include, or end with the locality
    %i[title address_street].each do |field|
      @data[field] = remove_occurrences(@data[field], locality)
    end
  end

  def remove_duplicated_street
    return if @data[:address_street].blank?

    street = @data[:address_street]

    # None of these fields should include, or end with the street
    %i[title].each do |field|
      @data[field] = remove_occurrences(@data[field], street)
    end
  end

  # Avoid leftover ' in' when all subsequent address info has been removed
  def remove_trailing_title_in
    @data[:title] = remove_occurrences(@data[:title], 'in')
  end

  # Remove the `needle` from `text` if it appears alone between commas,
  # or at the end of the part, following a space.
  def remove_occurrences(text, needle)
    return text if text.blank?

    needle = needle.downcase

    parts = text.split(',').map(&:squish)
    # Remove any matching sections
    parts.delete_if { |x| x.downcase == needle }
    # Remove trailing match (after space) from any section
    parts = parts.map { |x| x.downcase.end_with?(" #{needle}") ? x[0...-needle.length - 1] : x }

    parts.join(', ')
  end

  def html_to_plaintext(container_node)
    HtmlStripper.new(container_node).to_plaintext
  end
end
