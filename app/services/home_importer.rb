# frozen_string_literal: true

require 'nokogiri'

class HomeImporter
  def self.html_to_markdown(container_node)
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
