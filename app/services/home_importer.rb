# frozen_string_literal: true

require 'nokogiri'

class HomeImporter
  def initialize(page_html)
    @page_html = page_html
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

  def html_to_markdown(container_node)
    res = ''
    container_node.children.each do |child_node|
      case child_node.name
      when 'text', 'strong', 'em', 'b'
        res += child_node.text.squish
      when 'br'
        res += "\n"
      when 'ul', 'ol'
        res += html_to_markdown(child_node)
      when 'p', 'h1', 'h2', 'h3'
        res += "\n#{child_node.text.squish}"
      when 'li'
        res += "\n- #{child_node.text.squish}"
      else
        raise "Unexpected child_node name; #{child_node.name}"
      end
    end

    res
  end
end
