# frozen_string_literal: true

module CommentsHelper
  def markdown(text)
    redcarpet.render(text).html_safe
  end

  private

  def redcarpet
    @redcarpet ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  end
end
