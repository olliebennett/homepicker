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
    # Clean up street address to remove duplication; they often end in "street, Locality OUTCODE", eg '... Bath BA1'
    remove_trailing_outcode
    remove_trailing_locality
  end

  def remove_trailing_locality
    locality = @data[:address_locality]

    @data[:address_street] = @data[:address_street].chomp(locality).squish.chomp(',').squish
  end

  def remove_trailing_outcode
    return if @data[:postcode].nil?

    outcode = @data[:postcode][0...-3].squish

    @data[:address_street] = @data[:address_street].chomp(outcode).squish.chomp(',').squish
  end

  def html_to_plaintext(container_node)
    HtmlStripper.new(container_node).to_plaintext
  end
end
