module ApplicationHelper
  def render_markdown_paragraphs(text_with_newlines)
    capture do
      text_with_newlines.split("\n").reject(&:blank?).each do |line|
        concat content_tag(:p, line)
      end
    end
  end
end
