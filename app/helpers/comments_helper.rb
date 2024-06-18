# frozen_string_literal: true

module CommentsHelper
  def markdown(text)
    # We strip HTML tags from user input so it's safe
    # rubocop:disable Rails/OutputSafety
    redcarpet_markdown.render(text).html_safe
    # rubocop:enable Rails/OutputSafety
  end

  private

  def redcarpet_renderer
    Redcarpet::Render::HTML.new(escape_html: true)
  end

  def redcarpet_markdown
    @redcarpet_markdown ||= Redcarpet::Markdown.new(redcarpet_renderer, autolink: true, tables: true)
  end
end
