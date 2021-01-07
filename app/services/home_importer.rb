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

  # Remove the `needle` from `text` if it appears alone between commas,
  # or at the end of the part, following a space.
  def remove_occurrences(text, needle)
    return text if text.blank?

    needle = needle.downcase

    parts = text.split(',').map(&:squish)
    parts.delete_if { |x| x.downcase == needle || x.downcase.end_with?(" #{needle}") }

    parts.join(', ')
  end

  def html_to_plaintext(container_node)
    HtmlStripper.new(container_node).to_plaintext
  end
end
