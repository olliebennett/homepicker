# frozen_string_literal: true

class HtmlStripper
  PARENT_NODE_LIST = %w[ul ol div].freeze

  CHILDLESS_NODE_CONFIG = {
    b: '%<txt>s',
    br: "\n",
    em: '%<txt>s',
    i: '%<txt>s',
    h1: "\n%<txt>s",
    h2: "\n%<txt>s",
    h3: "\n%<txt>s",
    li: "\n- %<txt>s",
    p: "\n%<txt>s",
    strong: '%<txt>s',
    text: '%<txt>s'
  }.freeze

  def initialize(container_node)
    @container_node = container_node
  end

  def to_plaintext
    @container_node.children.map do |child_node|
      # Recursively parse parent elements to extract children as plaintext
      return HtmlStripper.new(child_node).to_plaintext if PARENT_NODE_LIST.include?(child_node.name)

      childless_node_to_text(child_node)
    end.join
  end

  private

  def childless_node_to_text(child_node)
    template = CHILDLESS_NODE_CONFIG.fetch(child_node.name.to_sym)
    format(template, txt: child_node.text.squish)
  end
end
