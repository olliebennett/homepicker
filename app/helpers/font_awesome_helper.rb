module FontAwesomeHelper
  def fas_icon(glyph, text: nil)
    content_tag(:i, text, class: "fas fa-#{glyph}")
  end
end
