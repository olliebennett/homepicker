module ApplicationHelper
  def render_markdown_paragraphs(text_with_newlines)
    capture do
      text_with_newlines.split("\n").reject(&:blank?).each do |line|
        concat content_tag(:p, line)
      end
    end
  end

  def title(text)
    content_for :title, text
  end

  def meta_tag(tag, text)
    content_for :"meta_#{tag}", text
  end
end
